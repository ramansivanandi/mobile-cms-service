package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.WidgetRule;
import com.dynamicui.repository.RulesRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/widget-rules")
@RequiredArgsConstructor
@Slf4j
public class WidgetRuleController {

    private final RulesRepository rulesRepository;

    @GetMapping("/widget/{widgetId}")
    public Mono<ResponseEntity<ApiResponse<List<WidgetRule>>>> getRulesByWidget(@PathVariable Long widgetId) {
        return rulesRepository.findByWidgetId(widgetId)
                .collectList()
                .map(rules -> ResponseEntity.ok(ApiResponse.success(rules)))
                .onErrorResume(e -> {
                    log.error("Error fetching rules for widget {}: {}", widgetId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch rules", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<WidgetRule>>> createRule(@RequestBody WidgetRule rule) {
        return rulesRepository.save(rule)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating rule: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create rule: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{ruleId}")
    public Mono<ResponseEntity<ApiResponse<WidgetRule>>> updateRule(@PathVariable Long ruleId, @RequestBody WidgetRule rule) {
        return rulesRepository.findById(ruleId)
                .flatMap(existing -> {
                    existing.setRuleType(rule.getRuleType());
                    existing.setRuleExpression(rule.getRuleExpression());
                    return rulesRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Rule not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating rule {}: {}", ruleId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update rule: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{ruleId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteRule(@PathVariable Long ruleId) {
        return rulesRepository.findById(ruleId)
                .flatMap(existing -> rulesRepository.deleteById(ruleId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Rule not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting rule {}: {}", ruleId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete rule: " + e.getMessage(), null)));
                });
    }
}
