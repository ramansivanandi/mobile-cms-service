package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.WidgetAction;
import com.dynamicui.repository.ActionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/widget-actions")
@RequiredArgsConstructor
@Slf4j
public class WidgetActionController {

    private final ActionRepository actionRepository;

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
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create action: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{actionId}")
    public Mono<ResponseEntity<ApiResponse<WidgetAction>>> updateAction(@PathVariable Long actionId, @RequestBody WidgetAction action) {
        return actionRepository.findById(actionId)
                .flatMap(existing -> {
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
                    return actionRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Action not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating action {}: {}", actionId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update action: " + e.getMessage(), null)));
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
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete action: " + e.getMessage(), null)));
                });
    }
}
