package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.Category;
import com.dynamicui.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/categories")
@RequiredArgsConstructor
@Slf4j
public class CategoryController {

    private final CategoryRepository categoryRepository;

    @GetMapping
    public Mono<ResponseEntity<ApiResponse<List<Category>>>> getAllCategories() {
        return categoryRepository.findAll()
                .collectList()
                .map(categories -> ResponseEntity.ok(ApiResponse.success(categories)))
                .onErrorResume(e -> {
                    log.error("Error fetching categories: {}", e.getMessage(), e);
                    return Mono
                            .just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch categories", null)));
                });
    }

    @GetMapping("/{categoryId}")
    public Mono<ResponseEntity<ApiResponse<Category>>> getCategory(@PathVariable Long categoryId) {
        return categoryRepository.findById(categoryId)
                .map(category -> ResponseEntity.ok(ApiResponse.success(category)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Category not found", null)))
                .onErrorResume(e -> {
                    log.error("Error fetching category {}: {}", categoryId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch category", null)));
                });
    }

    @GetMapping("/product/{productId}")
    public Mono<ResponseEntity<ApiResponse<List<Category>>>> getCategoriesByProduct(@PathVariable Long productId) {
        return categoryRepository.findByProductId(productId)
                .collectList()
                .map(categories -> ResponseEntity.ok(ApiResponse.success(categories)))
                .onErrorResume(e -> {
                    log.error("Error fetching categories for product {}: {}", productId, e.getMessage(), e);
                    return Mono
                            .just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch categories", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<Category>>> createCategory(@RequestBody Category category) {
        return categoryRepository.save(category)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating category: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100003", "Failed to create category: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{categoryId}")
    public Mono<ResponseEntity<ApiResponse<Category>>> updateCategory(@PathVariable Long categoryId,
            @RequestBody Category category) {
        return categoryRepository.findById(categoryId)
                .flatMap(existing -> {
                    existing.setName(category.getName());
                    existing.setDescription(category.getDescription());
                    if (category.getProductId() != null) {
                        existing.setProductId(category.getProductId());
                    }
                    return categoryRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Category not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating category {}: {}", categoryId, e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100004", "Failed to update category: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{categoryId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteCategory(@PathVariable Long categoryId) {
        return categoryRepository.findById(categoryId)
                .flatMap(existing -> categoryRepository.deleteById(categoryId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Category not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting category {}: {}", categoryId, e.getMessage(), e);
                    return Mono.just(ResponseEntity
                            .ok(ApiResponse.error("100005", "Failed to delete category: " + e.getMessage(), null)));
                });
    }
}
