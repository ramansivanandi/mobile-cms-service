package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.WidgetProps;
import com.dynamicui.repository.PropertyRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/widget-properties")
@RequiredArgsConstructor
@Slf4j
public class WidgetPropertyController {

    private final PropertyRepository propertyRepository;

    @GetMapping("/widget/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<List<WidgetProps>>>> getPropertiesByWidget(@PathVariable Long widgetId) {
        return propertyRepository.findByWidgetId(widgetId)
                .collectList()
                .map(properties -> ResponseEntity.ok(ApiResponse.success(properties)))
                .onErrorResume(e -> {
                    log.error("Error fetching properties for widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch properties", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<WidgetProps>>> createProperty(@RequestBody WidgetProps property) {
        return propertyRepository.save(property)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating property: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create property: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{propId}")
    public Mono<ResponseEntity<ApiResponse<WidgetProps>>> updateProperty(@PathVariable Long propId, @RequestBody WidgetProps property) {
        return propertyRepository.findById(propId)
                .flatMap(existing -> {
                    existing.setPropKey(property.getPropKey());
                    existing.setPropValue(property.getPropValue());
                    return propertyRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Property not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating property {}: {}", propId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update property: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{propId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteProperty(@PathVariable Long propId) {
        return propertyRepository.findById(propId)
                .flatMap(existing -> propertyRepository.deleteById(propId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Property not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting property {}: {}", propId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete property: " + e.getMessage(), null)));
                });
    }

    @PostMapping("/batch")
    public Mono<ResponseEntity<ApiResponse<List<WidgetProps>>>> createPropertiesBatch(@RequestBody List<WidgetProps> properties) {
        return Flux.fromIterable(properties)
                .flatMap(propertyRepository::save)
                .collectList()
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating properties batch: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create properties: " + e.getMessage(), null)));
                });
    }
}
