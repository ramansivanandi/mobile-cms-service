package com.dynamicui.controller;

import com.dynamicui.dto.UiConfigResponse;
import com.dynamicui.service.UiConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/ui-config")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "UI Configuration", description = "API for retrieving dynamic UI configuration")
public class UiConfigController {

    private final UiConfigService uiConfigService;

    @GetMapping("/{productId}")
    @Operation(summary = "Get UI Configuration by Product ID", description = "Retrieves the complete UI configuration structure for a given product, including categories, pages, components, properties, rules, and data sources.")
    public Mono<ResponseEntity<UiConfigResponse>> getUiConfig(
            @Parameter(description = "Product ID", required = true, example = "1") @PathVariable Long productId) {

        log.info("Received request for UI configuration with productId: {}", productId);

        return uiConfigService.getUiConfig(productId)
                .map(ResponseEntity::ok)
                .onErrorResume(RuntimeException.class, e -> {
                    log.error("Error retrieving UI configuration for productId {}: {}", productId, e.getMessage());
                    return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND).build());
                })
                .onErrorResume(Exception.class, e -> {
                    log.error("Unexpected error retrieving UI configuration for productId {}: {}", productId,
                            e.getMessage(), e);
                    return Mono.just(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build());
                });
    }

    @PostMapping("/post/ins")
    public Mono<Map<String, Object>> testPostInsurance(@RequestBody Map<String, Object> map) {
        Map<String, Object> resp = new HashMap<>();
        resp.putIfAbsent("refNo", UUID.randomUUID().toString().replace("-", "").substring(0, 6));
        return Mono.just(resp);
    }
}
