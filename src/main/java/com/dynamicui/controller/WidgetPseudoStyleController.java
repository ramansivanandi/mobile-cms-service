package com.dynamicui.controller;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.dto.PseudoStyleDto;
import com.dynamicui.dto.UpdatePseudoStyleRequest;
import com.dynamicui.entity.WidgetPseudoStyle;
import com.dynamicui.service.WidgetPseudoStyleService;

import reactor.core.publisher.Mono;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/widgets")
@RequiredArgsConstructor
@Slf4j
public class WidgetPseudoStyleController {

    private final WidgetPseudoStyleService service;

    // GET /widgets/{id}/pseudo-styles
    @GetMapping("/{id}/pseudo-styles")
    public Mono<ApiResponse<List<WidgetPseudoStyle>>> getPseudoStyles(
            @PathVariable Long id) {

        return service.getByWidgetId(id)
                .collectList()
                .flatMap(list -> {

                    if (list.isEmpty()) {
                        return Mono.just(
                                new ApiResponse<>(
                                        new ApiResponse.Status("404001",
                                                "No pseudo styles found for widgetId: " + id),
                                        null));
                    }

                    return Mono.just(
                            new ApiResponse<>(
                                    new ApiResponse.Status("000000", "SUCCESS"),
                                    list));
                });

    }

    // POST /widgets/{id}/pseudo-styles
    @PostMapping("/{id}/pseudo-styles")
    public Mono<ApiResponse<WidgetPseudoStyle>> createPseudoStyle(
            @PathVariable Long id,
            @RequestBody PseudoStyleDto request) {

        WidgetPseudoStyle style = new WidgetPseudoStyle();
        style.setWidgetId(id);
        style.setSelector(request.getSelector());
        style.setPropKey(request.getPropKey());
        style.setPropValue(request.getPropValue());
        style.setRemarks(request.getRemarks());
        log.info("createPse id:{}, setSelector{}", id, request.getSelector());
        return service.create(style)
                .map(saved -> new ApiResponse<>(
                        new ApiResponse.Status("000000", "SUCCESS"),
                        saved))
                .switchIfEmpty(
                        Mono.just(ApiResponse.error("10001", "Unable to create pseudo style")));

    }

    // ================= UPDATE =================
    @PutMapping("/{widgetId}/pseudo-styles/{propId}")
    public Mono<ApiResponse<WidgetPseudoStyle>> updatePseudoStyle(
            @PathVariable Long widgetId,
            @PathVariable Long propId,
            @RequestBody UpdatePseudoStyleRequest request) {

        return service.update(widgetId,
                propId,
                request.getSelector(),
                request.getPropKey(),
                request.getPropValue(),
                request.getRemarks())
                .map(updated -> new ApiResponse<>(
                        new ApiResponse.Status("000000", "UPDATED SUCCESSFULLY"),
                        updated));
    }

    // ================= DELETE =================
    @DeleteMapping("/{widgetId}/pseudo-styles/{propId}")
    public Mono<ApiResponse<String>> deletePseudoStyle(
            @PathVariable Long widgetId,
            @PathVariable Long propId) {

        return service.delete(widgetId, propId)
                .then(Mono.just(
                        new ApiResponse<>(
                                new ApiResponse.Status("000000", "DELETED SUCCESSFULLY"),
                                "Deleted")));
    }

}