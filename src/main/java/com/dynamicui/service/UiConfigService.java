package com.dynamicui.service;

import com.dynamicui.dto.*;
import com.dynamicui.entity.*;
import com.dynamicui.repository.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class UiConfigService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final PageRepository pageRepository;
    private final WidgetRepository widgetRepository;
    private final PropertyRepository propertyRepository;
    private final RulesRepository rulesRepository;
    private final DataSourceRepository dataSourceRepository;
    private final ActionRepository actionRepository;
    private final OnLoadServiceRepository onLoadServiceRepository;
    private final ObjectMapper objectMapper;

    private final WidgetPseudoStyleRepository pseudoStyleRepository;

    public Mono<UiConfigResponse> getUiConfig(Long productId) {
        log.info("Fetching UI configuration for productId: {}", productId);

        return productRepository.findById(productId)
                .switchIfEmpty(Mono.error(new RuntimeException("Product not found with id: " + productId)))
                .flatMap(this::buildUiConfigResponse)
                .onErrorMap(e -> {
                    log.error("Error building UI config for productId {}: {}", productId, e.getMessage(), e);
                    return new RuntimeException("Failed to retrieve UI configuration: " +
                            (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName()), e);
                });
    }

    private Mono<UiConfigResponse> buildUiConfigResponse(Product product) {
        return categoryRepository.findByProductId(product.getProductId())
                .sort(Comparator.comparing(Category::getCategoryId))
                .flatMapSequential(this::buildCategoryDto)
                .collectList()
                .map(categoryDtos -> UiConfigResponse.builder()
                        .product(product.getName() != null ? product.getName() : "")
                        .categories(categoryDtos)
                        .build());
    }

    private Mono<CategoryDto> buildCategoryDto(Category category) {
        return pageRepository.findByCategoryId(category.getCategoryId())
                .sort(Comparator.comparing(Page::getOrderNo, Comparator.nullsLast(Comparator.naturalOrder())))
                .flatMapSequential(this::buildPageDto)
                .collectList()
                .map(pageDtos -> CategoryDto.builder()
                        .name(category.getName() != null ? category.getName() : "")
                        .pages(pageDtos)
                        .build());
    }

    private Mono<PageDto> buildPageDto(Page page) {
        Mono<List<ComponentDto>> componentsMono = widgetRepository
                .findByPageIdAndParentWidgetIdIsNullOrderByOrderNo(page.getPageId())
                .flatMapSequential(this::buildComponentDtoWithChildren)
                .collectList();

        Mono<List<OnLoadServiceDto>> onLoadServicesMono = onLoadServiceRepository.findByPageId(page.getPageId())
                .map(this::buildOnLoadServiceDto)
                .collectList();

        String layoutType = page.getLayoutType();
        if (layoutType == null || layoutType.trim().isEmpty()) {
            layoutType = "vertical";
        }
        final String finalLayoutType = layoutType;
        log.info("Building PageDto for pageId: {}, title: {}, layoutType: {}", page.getPageId(), page.getTitle(),
                finalLayoutType);
        return Mono.zip(componentsMono, onLoadServicesMono)
                .map(tuple -> PageDto.builder()
                        .title(page.getTitle())
                        .order(page.getOrderNo())
                        .layoutType(finalLayoutType)
                        .columnsPerRow(page.getColumnsPerRow())
                        .components(tuple.getT1())
                        .onLoadServices(tuple.getT2().isEmpty() ? null : tuple.getT2())
                        .build())
                .doOnSuccess(pageDto -> {
                    try {
                        ObjectMapper mapper = new ObjectMapper();
                        String json = mapper.writeValueAsString(pageDto);
                        log.info("Successfully built PageDto for pageId: {}, title: {}, json: {}", page.getPageId(),
                                page.getTitle(), json);
                    } catch (JsonProcessingException e) {
                        log.error("Error serializing PageDto to JSON", e);

                    }

                    log.info(
                            "Successfully built PageDto for pageId: {}, title: {}, layoutType: {}, components: {}, onLoadServices: {}",
                            page.getPageId(), page.getTitle(), finalLayoutType,
                            pageDto.getComponents() != null ? pageDto.getComponents().size() : 0,
                            pageDto.getOnLoadServices() != null ? pageDto.getOnLoadServices().size() : 0);
                })

                .doOnError(e -> log.error("Error building PageDto for pageId: {}, title: {}, layoutType: {}: {}",
                        page.getPageId(), page.getTitle(), finalLayoutType, e.getMessage(), e));
    }

    private Mono<ComponentDto> buildComponentDtoWithChildren(Widget widget) {
        return buildComponentDto(widget)
                .flatMap(componentDto -> widgetRepository.findByParentWidgetIdOrderByOrderNo(widget.getWidgetId())
                        .flatMapSequential(this::buildComponentDtoWithChildren)
                        .collectList()
                        .map(children -> {
                            if (!children.isEmpty()) {
                                componentDto.setChildren(children);
                            }
                            return componentDto;
                        }));
    }

    private Mono<ComponentDto> buildComponentDto(Widget widget) {
        Mono<Map<String, String>> propertiesMono = propertyRepository.findByWidgetId(widget.getWidgetId())
                .filter(prop -> prop.getPropKey() != null)
                .collectList()
                .map(props -> props.stream()
                        .collect(Collectors.toMap(
                                WidgetProps::getPropKey,
                                prop -> prop.getPropValue() != null ? prop.getPropValue() : "",
                                (v1, v2) -> v1,
                                LinkedHashMap::new)));

        Mono<List<RuleDto>> rulesMono = rulesRepository.findByWidgetId(widget.getWidgetId())
                .filter(rule -> rule.getRuleType() != null)
                .map(rule -> RuleDto.builder()
                        .type(rule.getRuleType())
                        .expression(rule.getRuleExpression() != null ? rule.getRuleExpression() : "")
                        .build())
                .collectList();

        Mono<Optional<Object>> dataSourceMono = dataSourceRepository.findByWidgetId(widget.getWidgetId())
                .collectList()
                .map(dsList -> {
                    if (dsList.isEmpty())
                        return Optional.empty();
                    UIDataSource ds = dsList.get(0);
                    if ("static".equalsIgnoreCase(ds.getSourceType())) {
                        try {
                            if (ds.getSourceValue() != null && !ds.getSourceValue().trim().isEmpty()) {
                                return Optional.of(objectMapper.readValue(ds.getSourceValue(), Object.class));
                            }
                        } catch (Exception e) {
                            log.warn("Failed to parse data source JSON for widget {}: {}",
                                    widget.getWidgetId(), e.getMessage());
                            return Optional.<Object>of(ds.getSourceValue());
                        }
                    }
                    return ds.getSourceValue() != null ? Optional.<Object>of(ds.getSourceValue()) : Optional.empty();
                });

        Mono<List<ActionDto>> actionsMono = actionRepository.findByWidgetIdOrderByOrderNo(widget.getWidgetId())
                .filter(action -> action.getIsEnabled() == null || "Y".equalsIgnoreCase(action.getIsEnabled()))
                .map(this::buildActionDto)
                .collectList();

        // Mono<ApiResponse<List<WidgetPseudoStyle>>>
        // widgetPseudoStyleList=getPseudoStyles(widget.getWidgetId());
        Mono<List<WidgetPseudoStyle>> widgetPseudoStyleList = pseudoStyleRepository.findByWidgetId(widget.getWidgetId())
                .collectList();
        return Mono.zip(propertiesMono, rulesMono, dataSourceMono, actionsMono, widgetPseudoStyleList)
                .map(tuple -> ComponentDto.builder()
                        .type(widget.getType() != null ? widget.getType() : "")
                        .label(widget.getLabel())
                        .name(widget.getName() != null ? widget.getName() : "")
                        .order(widget.getOrderNo())
                        .properties(tuple.getT1().isEmpty() ? null : tuple.getT1())
                        .rules(tuple.getT2().isEmpty() ? null : tuple.getT2())
                        .dataSource(tuple.getT3().orElse(null))
                        .actions(tuple.getT4().isEmpty() ? null : tuple.getT4())
                        .pseudoStyles(
                                tuple.getT5().isEmpty() ? null : tuple.getT5())
                        .build());
    }

    private ActionDto buildActionDto(WidgetAction action) {
        Object payloadTemplate = null;
        if (action.getPayloadTemplate() != null && !action.getPayloadTemplate().trim().isEmpty()) {
            try {
                payloadTemplate = objectMapper.readValue(action.getPayloadTemplate(), Object.class);
            } catch (Exception e) {
                log.warn("Failed to parse payload template JSON for action {}: {}",
                        action.getActionId(), e.getMessage());
                payloadTemplate = action.getPayloadTemplate();
            }
        }

        Object headers = null;
        if (action.getHeaders() != null && !action.getHeaders().trim().isEmpty()) {
            try {
                headers = objectMapper.readValue(action.getHeaders(), Object.class);
            } catch (Exception e) {
                log.warn("Failed to parse headers JSON for action {}: {}",
                        action.getActionId(), e.getMessage());
                headers = action.getHeaders();
            }
        }

        Object queryParams = null;
        if (action.getQueryParams() != null && !action.getQueryParams().trim().isEmpty()) {
            try {
                queryParams = objectMapper.readValue(action.getQueryParams(), Object.class);
            } catch (Exception e) {
                log.warn("Failed to parse query params JSON for action {}: {}",
                        action.getActionId(), e.getMessage());
                queryParams = action.getQueryParams();
            }
        }

        return ActionDto.builder()
                .name(action.getActionName())
                .type(action.getActionType())
                .triggerEvent(action.getTriggerEvent())
                .httpMethod(action.getHttpMethod())
                .endpointUrl(action.getEndpointUrl())
                .payloadTemplate(payloadTemplate)
                .payloadType(action.getPayloadType())
                .headers(headers)
                .queryParams(queryParams)
                .successHandler(action.getSuccessHandler())
                .errorHandler(action.getErrorHandler())
                .timeout(action.getTimeoutMs())
                .order(action.getOrderNo())
                .enabled("Y".equalsIgnoreCase(action.getIsEnabled()))
                .conditionExpression(action.getConditionExpression())
                .build();
    }

    private OnLoadServiceDto buildOnLoadServiceDto(OnLoadService service) {
        Object payload = null;
        if (service.getPayload() != null && !service.getPayload().trim().isEmpty()) {
            try {
                payload = objectMapper.readValue(service.getPayload(), Object.class);
            } catch (Exception e) {
                log.warn("Failed to parse payload JSON for onLoadService {}: {}",
                        service.getOnLoadServiceId(), e.getMessage());
                payload = service.getPayload();
            }
        }

        Object headers = null;
        if (service.getHeaders() != null && !service.getHeaders().trim().isEmpty()) {
            try {
                headers = objectMapper.readValue(service.getHeaders(), Object.class);
            } catch (Exception e) {
                log.warn("Failed to parse headers JSON for onLoadService {}: {}",
                        service.getOnLoadServiceId(), e.getMessage());
                headers = service.getHeaders();
            }
        }

        return OnLoadServiceDto.builder()
                .serviceId(service.getServiceId())
                .api(service.getApi())
                .httpMethod(service.getHttpMethod())
                .payload(payload)
                .headers(headers)
                .serviceIdentifier(service.getServiceIdentifier())
                .onSuccess(service.getOnSuccess())
                .onFailure(service.getOnFailure())
                .build();
    }

    public Mono<ApiResponse<List<WidgetPseudoStyle>>> getPseudoStyles(Long id) {

        return pseudoStyleRepository.findByWidgetId(id)
                .collectList()
                .map(list -> list.isEmpty()
                        ? new ApiResponse<>(
                                new ApiResponse.Status(
                                        "404001",
                                        "No pseudo styles found for widgetId: " + id),
                                null)
                        : new ApiResponse<>(
                                new ApiResponse.Status("000000", "SUCCESS"),
                                list));
    }
}
