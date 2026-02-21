package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.OnLoadService;
import com.dynamicui.repository.OnLoadServiceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/onload-services")
@RequiredArgsConstructor
@Slf4j
public class OnLoadServiceController {

    private final OnLoadServiceRepository onLoadServiceRepository;

    @GetMapping("/page/{pageId}")
    public Mono<ResponseEntity<ApiResponse<List<OnLoadService>>>> getServicesByPage(@PathVariable Long pageId) {
        return onLoadServiceRepository.findByPageId(pageId)
                .collectList()
                .map(services -> ResponseEntity.ok(ApiResponse.success(services)))
                .onErrorResume(e -> {
                    log.error("Error fetching onLoad services for page {}: {}", pageId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch onLoad services", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<OnLoadService>>> createService(@RequestBody OnLoadService service) {
        return onLoadServiceRepository.save(service)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating onLoad service: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create onLoad service: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{serviceId}")
    public Mono<ResponseEntity<ApiResponse<OnLoadService>>> updateService(@PathVariable Long serviceId, @RequestBody OnLoadService service) {
        return onLoadServiceRepository.findById(serviceId)
                .flatMap(existing -> {
                    existing.setServiceId(service.getServiceId());
                    existing.setApi(service.getApi());
                    existing.setHttpMethod(service.getHttpMethod());
                    existing.setPayload(service.getPayload());
                    existing.setHeaders(service.getHeaders());
                    existing.setServiceIdentifier(service.getServiceIdentifier());
                    existing.setOnSuccess(service.getOnSuccess());
                    existing.setOnFailure(service.getOnFailure());
                    return onLoadServiceRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "OnLoad service not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating onLoad service {}: {}", serviceId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update onLoad service: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{serviceId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteService(@PathVariable Long serviceId) {
        return onLoadServiceRepository.findById(serviceId)
                .flatMap(existing -> onLoadServiceRepository.deleteById(serviceId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "OnLoad service not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting onLoad service {}: {}", serviceId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete onLoad service: " + e.getMessage(), null)));
                });
    }
}
