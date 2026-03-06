package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.WidgetAction;
import com.dynamicui.repository.ActionRepository;
import io.r2dbc.postgresql.codec.Json;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/widget-actions")
@RequiredArgsConstructor
@Slf4j
public class WidgetActionController {

    private final ActionRepository actionRepository;
    private final DatabaseClient databaseClient;

    @GetMapping("/widget/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<List<WidgetAction>>>> getActionsByWidget(@PathVariable Long widgetId) {
        return actionRepository.findByWidgetIdOrderByOrderNo(widgetId)
                .collectList()
                .map(actions -> ResponseEntity.ok(ApiResponse.success(actions)))
                .onErrorResume(e -> {
                    log.error("Error fetching actions for widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch actions", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<WidgetAction>>> createAction(@RequestBody WidgetAction action) {
        if (action.getIsEnabled() == null) {
            action.setIsEnabled("Y");
        }
        return actionRepository.save(action)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating action: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100003", "Failed to create action: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{actionId}")
    public Mono<ResponseEntity<ApiResponse<WidgetAction>>> updateAction(@PathVariable Long actionId,
            @RequestBody WidgetAction action) {
        return actionRepository.findById(actionId)
                .flatMap(existing -> {
                    existing.setWidgetId(action.getWidgetId());
                    existing.setActionName(action.getActionName());
                    existing.setActionType(action.getActionType());
                    existing.setTriggerEvent(action.getTriggerEvent());
                    existing.setHttpMethod(action.getHttpMethod());
                    existing.setEndpointUrl(action.getEndpointUrl());
                    existing.setPayloadTemplate(action.getPayloadTemplate());
                    existing.setPayloadType(action.getPayloadType());
                    existing.setHeaders(action.getHeaders());
                    existing.setQueryParams(action.getQueryParams());
                    existing.setSuccessHandler(action.getSuccessHandler());
                    existing.setErrorHandler(action.getErrorHandler());
                    existing.setTimeoutMs(action.getTimeoutMs());
                    existing.setOrderNo(action.getOrderNo());
                    existing.setIsEnabled(action.getIsEnabled() != null ? action.getIsEnabled() : "Y");
                    existing.setConditionExpression(action.getConditionExpression());

                    DatabaseClient.GenericExecuteSpec spec = databaseClient.sql(
                            "UPDATE widget_action SET widget_id = :widgetId, action_name = :actionName, " +
                            "action_type = :actionType, trigger_event = :triggerEvent, http_method = :httpMethod, " +
                            "endpoint_url = :endpointUrl, payload_template = :payloadTemplate, payload_type = :payloadType, " +
                            "headers = :headers, query_params = :queryParams, success_handler = :successHandler, " +
                            "error_handler = :errorHandler, timeout_ms = :timeoutMs, order_no = :orderNo, " +
                            "is_enabled = :isEnabled, condition_expression = :conditionExpression " +
                            "WHERE action_id = :actionId")
                            .bind("widgetId", existing.getWidgetId())
                            .bind("actionName", existing.getActionName())
                            .bind("actionType", existing.getActionType())
                            .bind("actionId", existing.getActionId());

                    spec = bindOrNull(spec, "triggerEvent", existing.getTriggerEvent(), String.class);
                    spec = bindOrNull(spec, "httpMethod", existing.getHttpMethod(), String.class);
                    spec = bindOrNull(spec, "endpointUrl", existing.getEndpointUrl(), String.class);
                    spec = bindJsonOrNull(spec, "payloadTemplate", existing.getPayloadTemplate());
                    spec = bindOrNull(spec, "payloadType", existing.getPayloadType(), String.class);
                    spec = bindJsonOrNull(spec, "headers", existing.getHeaders());
                    spec = bindJsonOrNull(spec, "queryParams", existing.getQueryParams());
                    spec = bindOrNull(spec, "successHandler", existing.getSuccessHandler(), String.class);
                    spec = bindOrNull(spec, "errorHandler", existing.getErrorHandler(), String.class);
                    spec = bindOrNull(spec, "timeoutMs", existing.getTimeoutMs(), Integer.class);
                    spec = bindOrNull(spec, "orderNo", existing.getOrderNo(), Integer.class);
                    spec = bindOrNull(spec, "isEnabled", existing.getIsEnabled(), String.class);
                    spec = bindOrNull(spec, "conditionExpression", existing.getConditionExpression(), String.class);

                    return spec.fetch().rowsUpdated().thenReturn(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Action not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating action {}: {}", actionId, e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100004", "Failed to update action: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{actionId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteAction(@PathVariable Long actionId) {
        return actionRepository.findById(actionId)
                .flatMap(existing -> actionRepository.deleteById(actionId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Action not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting action {}: {}", actionId, e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100005", "Failed to delete action: " + e.getMessage(), null)));
                });
    }

    private DatabaseClient.GenericExecuteSpec bindOrNull(DatabaseClient.GenericExecuteSpec spec,
            String name, Object value, Class<?> type) {
        return value != null ? spec.bind(name, value) : spec.bindNull(name, type);
    }

    private DatabaseClient.GenericExecuteSpec bindJsonOrNull(DatabaseClient.GenericExecuteSpec spec,
            String name, String value) {
        return value != null ? spec.bind(name, Json.of(value)) : spec.bindNull(name, Json.class);
    }
}
