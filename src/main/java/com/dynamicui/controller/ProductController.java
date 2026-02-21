package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.entity.Product;
import com.dynamicui.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/products")
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductRepository productRepository;

    @GetMapping
    public Mono<ResponseEntity<ApiResponse<List<Product>>>> getAllProducts() {
        return productRepository.findAll()
                .collectList()
                .map(products -> ResponseEntity.ok(ApiResponse.success(products)))
                .onErrorResume(e -> {
                    log.error("Error fetching products: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch products", null)));
                });
    }

    @GetMapping("/{productId}")
    public Mono<ResponseEntity<ApiResponse<Product>>> getProduct(@PathVariable Long productId) {
        return productRepository.findById(productId)
                .map(product -> ResponseEntity.ok(ApiResponse.success(product)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Product not found", null)))
                .onErrorResume(e -> {
                    log.error("Error fetching product {}: {}", productId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100001", "Failed to fetch product", null)));
                });
    }

    @PostMapping
    public Mono<ResponseEntity<ApiResponse<Product>>> createProduct(@RequestBody Product product) {
        return productRepository.save(product)
                .map(saved -> ResponseEntity.ok(ApiResponse.success(saved)))
                .onErrorResume(e -> {
                    log.error("Error creating product: {}", e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100003", "Failed to create product: " + e.getMessage(), null)));
                });
    }

    @PutMapping("/{productId}")
    public Mono<ResponseEntity<ApiResponse<Product>>> updateProduct(@PathVariable Long productId, @RequestBody Product product) {
        return productRepository.findById(productId)
                .flatMap(existing -> {
                    existing.setName(product.getName());
                    existing.setDescription(product.getDescription());
                    return productRepository.save(existing);
                })
                .map(updated -> ResponseEntity.ok(ApiResponse.success(updated)))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Product not found", null)))
                .onErrorResume(e -> {
                    log.error("Error updating product {}: {}", productId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100004", "Failed to update product: " + e.getMessage(), null)));
                });
    }

    @DeleteMapping("/{productId}")
    public Mono<ResponseEntity<ApiResponse<Void>>> deleteProduct(@PathVariable Long productId) {
        return productRepository.findById(productId)
                .flatMap(existing -> productRepository.deleteById(productId)
                        .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null)))))
                .defaultIfEmpty(ResponseEntity.ok(ApiResponse.error("100002", "Product not found", null)))
                .onErrorResume(e -> {
                    log.error("Error deleting product {}: {}", productId, e.getMessage(), e);
                    return Mono.just(ResponseEntity.ok(ApiResponse.error("100005", "Failed to delete product: " + e.getMessage(), null)));
                });
    }
}
