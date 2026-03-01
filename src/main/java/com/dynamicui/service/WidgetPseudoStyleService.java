package com.dynamicui.service;

import org.springframework.stereotype.Service;

import com.dynamicui.constants.ErrorCode;

import com.dynamicui.dto.BusinessException;
import com.dynamicui.entity.WidgetPseudoStyle;
import com.dynamicui.repository.WidgetPseudoStyleRepository;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class WidgetPseudoStyleService {

    private final WidgetPseudoStyleRepository repository;

    public Flux<WidgetPseudoStyle> getByWidgetId(Long widgetId) {
        return repository.findByWidgetId(widgetId);
    }

    public Mono<WidgetPseudoStyle> create(WidgetPseudoStyle style) {
        log.info("Error in Creating records style:{}", style);
        return repository.save(style);
    }

    // UPDATE
    public Mono<WidgetPseudoStyle> update(Long widgetId,
            Long propId,
            String selector,
            String propKey,
            String propValue,
            String remarks) {

        return repository.findByPropIdAndWidgetId(propId, widgetId)
                .switchIfEmpty(Mono.error(new BusinessException(
                        "10002",
                        "Pseudo style not found")))
                .flatMap(existing -> {
                    existing.setSelector(selector);
                    existing.setPropKey(propKey);
                    existing.setPropValue(propValue);
                    existing.setRemarks(remarks);
                    return repository.save(existing);
                });
    }

    // ApiResponse.error("100003", "Failed to create property: "

    // DELETE
    public Mono<Void> delete(Long widgetId, Long propId) {

        return repository.findByPropIdAndWidgetId(propId, widgetId)
                .switchIfEmpty(Mono.error(new BusinessException(
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.code(),
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.message())))
                .flatMap(repository::delete);
    }

    // DELETE
    public Mono<Void> deleteByPropKey(Long widgetId, Long propId, String propKey) {

        return repository.findByPropIdAndWidgetIdAndPropKey(propId, widgetId, propKey)
                .switchIfEmpty(Mono.error(new BusinessException(
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.code(),
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.message())))
                .flatMap(repository::delete);
    }

    public Mono<Void> deleteBySelector(String widgetId, String propId, String selector) {

        return repository.findByPropIdAndWidgetIdAndSelector(propId, widgetId, selector)
                .switchIfEmpty(Mono.error(new BusinessException(
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.code(),
                        ErrorCode.PSEUDO_STYLE_NOT_FOUND.message())))
                .flatMap(repository::delete);
    }

}