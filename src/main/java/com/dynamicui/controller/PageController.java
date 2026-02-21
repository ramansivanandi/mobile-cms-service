package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.Page;
import com.dynamicui.repository.PageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/pages")
@RequiredArgsConstructor
@Slf4j
public class PageController {

    private final PageRepository pageRepository;

    @GetMapping
    public Mono<ResponseEntity<ApiResponse<List<Page>>>> getAllPages(@RequestParam(required = false) Long categoryId) {
        return (categoryId != null
                ? pageRepository.findByCategoryId(categoryId).collectList()
                : pageRepository.findAll().collectList())
                .map(pages -> ResponseEntity.ok(ApiResponse.success(pages)))
                .onErrorResume(e -> {
                    log.error("Error fetching pages: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch pages", null)));
                });
    }

    @GetMapping("/{pageId}")
    public Mono<ResponseEntity<ApiResponse<Page>>> getPage(@PathVariable Long pageId) {
        return pageRepository.findById(pageId)
                .map(page -> ResponseEntity.ok(ApiResponse.success(page)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Page not found", null)))
                .onErrorResume(e -> {
                    log.error("Error fetching page {}: {}", pageId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch page", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<Page>>> createPage(@RequestBody Page page) {
        if (page.getLayoutType() == null || page.getLayoutType().trim().isEmpty()) {
            page.setLayoutType("vertical");
        }
        return pageRepository.save(page)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating page: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create page: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{pageId}")
    public Mono<ResponseEntity<ApiResponse<Page>>> updatePage(@PathVariable Long pageId, @RequestBody Page page) {
        return pageRepository.findById(pageId)
                .flatMap(existing -> {
                    existing.setTitle(page.getTitle());
                    existing.setOrderNo(page.getOrderNo());
                    existing.setLayoutType(page.getLayoutType() != null && !page.getLayoutType().trim().isEmpty()
                            ? page.getLayoutType() : "vertical");
                    existing.setColumnsPerRow(page.getColumnsPerRow());
                    if (page.getCategoryId() != null) {
                        existing.setCategoryId(page.getCategoryId());
                    }
                    return pageRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Page not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating page {}: {}", pageId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update page: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{pageId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deletePage(@PathVariable Long pageId) {
        return pageRepository.findById(pageId)
                .flatMap(existing -> pageRepository.deleteById(pageId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Page not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting page {}: {}", pageId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete page: " + e.getMessage(), null)));
                });
    }
}
