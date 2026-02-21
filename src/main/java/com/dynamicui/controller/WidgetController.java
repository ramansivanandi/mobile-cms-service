package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.Widget;
import com.dynamicui.repository.WidgetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/widgets")
@RequiredArgsConstructor
@Slf4j
public class WidgetController {

    private final WidgetRepository widgetRepository;

    @GetMapping("/page/{pageId}")
    public Mono<ResponseEntity<ApiResponse<List<Widget>>>> getWidgetsByPage(@PathVariable Long pageId) {
        return widgetRepository.findByPageIdOrderByOrderNo(pageId)
                .collectList()
                .map(widgets -> ResponseEntity.ok(ApiResponse.success(widgets)))
                .onErrorResume(e -> {
                    log.error("Error fetching widgets for page {}: {}", pageId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch widgets", null)));
                });
    }

    @GetMapping("/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<Widget>>> getWidget(@PathVariable Long widgetId) {
        return widgetRepository.findById(widgetId)
                .map(widget -> ResponseEntity.ok(ApiResponse.success(widget)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Widget not found", null)))
                .onErrorResume(e -> {
                    log.error("Error fetching widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch widget", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<Widget>>> createWidget(@RequestBody Widget widget) {
        return widgetRepository.save(widget)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating widget: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create widget: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<Widget>>> updateWidget(@PathVariable Long widgetId, @RequestBody Widget widget) {
        return widgetRepository.findById(widgetId)
                .flatMap(existing -> {
                    existing.setType(widget.getType());
                    existing.setName(widget.getName());
                    existing.setLabel(widget.getLabel());
                    existing.setOrderNo(widget.getOrderNo());
                    if (widget.getPageId() != null) {
                        existing.setPageId(widget.getPageId());
                    }
                    existing.setParentWidgetId(widget.getParentWidgetId());
                    return widgetRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Widget not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update widget: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteWidget(@PathVariable Long widgetId) {
        return widgetRepository.findById(widgetId)
                .flatMap(existing -> widgetRepository.deleteById(widgetId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Widget not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete widget: " + e.getMessage(), null)));
                });
    }
}
