package com.dynamicui.controller;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.dto.BusinessException;
import com.dynamicui.dto.ImageUploadResponse;
import com.dynamicui.dto.WidgetImageAssignRequest;
import com.dynamicui.dto.WidgetImageResponse;
import com.dynamicui.service.ImageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/builder/images")
@RequiredArgsConstructor
@Slf4j
public class ImageController {

        private final ImageService imageService;

        // -------------------------------------------------------------------------
        // Upload
        // -------------------------------------------------------------------------

        /**
         * POST /api/builder/images/upload
         * Accepts multipart/form-data with a "file" part.
         * Validates MIME type, file size, and magic bytes before storing.
         */
        @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        public Mono<ResponseEntity<ApiResponse<ImageUploadResponse>>> uploadImage(
                        @RequestPart("file") FilePart filePart) {

                return imageService.uploadImage(filePart)
                                .map(response -> ResponseEntity.ok(ApiResponse.success(response)))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                                                .body(ApiResponse.error(e.getCode(), e.getMessage()))))
                                .onErrorResume(e -> {
                                        log.error("Unexpected error during image upload: {}", e.getMessage(), e);
                                        return Mono.just(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                                        .body(ApiResponse.error("IMG-500-01",
                                                                        "Failed to upload image")));
                                });
        }

        // -------------------------------------------------------------------------
        // Metadata
        // -------------------------------------------------------------------------

        /**
         * GET /api/builder/images/{imageId}
         * Returns stored metadata (filename, type, size, URL). Does NOT return binary.
         */
        @GetMapping("/{imageId}")
        public Mono<ResponseEntity<ApiResponse<ImageUploadResponse>>> getImageMetadata(
                        @PathVariable Long imageId) {

                return imageService.getImageMetadata(imageId)
                                .map(response -> ResponseEntity.ok(ApiResponse.success(response)))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                                                .body(ApiResponse.error(e.getCode(), e.getMessage()))))
                                .onErrorResume(e -> {
                                        log.error("Error fetching image metadata {}: {}", imageId, e.getMessage(), e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01",
                                                                        "Failed to fetch image metadata")));
                                });
        }

        // -------------------------------------------------------------------------
        // Binary image serving
        // -------------------------------------------------------------------------

        /**
         * GET /api/builder/images/{imageId}/content
         * Streams the raw image bytes with the correct Content-Type header.
         * Includes cache headers suitable for static assets.
         */
        @GetMapping("/{imageId}/content")
        public Mono<ResponseEntity<byte[]>> getImageContent(@PathVariable Long imageId) {
                return imageService.getImageContent(imageId)
                                .map(tuple -> ResponseEntity.ok()
                                                .contentType(MediaType.parseMediaType(tuple.getT2()))
                                                .header("Cache-Control", "public, max-age=86400")
                                                .header("Content-Disposition", "inline")
                                                .body(tuple.getT1()))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                                                .<byte[]>build()))
                                .onErrorResume(e -> {
                                        log.error("Error serving image content {}: {}", imageId, e.getMessage(), e);
                                        return Mono.just(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                                        .<byte[]>build());
                                });
        }

        // -------------------------------------------------------------------------
        // Delete image
        // -------------------------------------------------------------------------

        /**
         * DELETE /api/builder/images/{imageId}
         * Removes the DB record and the file on disk.
         * The FK cascade in widget_images handles orphan cleanup automatically.
         */
        @DeleteMapping("/{imageId}")
        public Mono<ResponseEntity<ApiResponse<Void>>> deleteImage(@PathVariable Long imageId) {
                return imageService.deleteImage(imageId)
                                .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null))))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                                                .body(ApiResponse.error(e.getCode(), e.getMessage()))))
                                .onErrorResume(e -> {
                                        log.error("Error deleting image {}: {}", imageId, e.getMessage(), e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01", "Failed to delete image")));
                                });
        }

        // -------------------------------------------------------------------------
        // Widget ↔ Image assignment
        // -------------------------------------------------------------------------

        /**
         * POST /api/builder/images/widgets/{widgetId}/assign
         * Body: { "imageId": 1, "imageRole": "BACKGROUND" }
         * Roles: ICON | BACKGROUND | THUMBNAIL | BANNER
         * One image per role per widget (upsert on conflict).
         */
        @PostMapping("/widgets/{widgetId}/assign")
        public Mono<ResponseEntity<ApiResponse<Void>>> assignImageToWidget(
                        @PathVariable Long widgetId,
                        @RequestBody WidgetImageAssignRequest request) {

                return imageService.assignImageToWidget(widgetId, request.getImageId(), request.getImageRole())
                                .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null))))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                                                .body(ApiResponse.error(e.getCode(), e.getMessage()))))
                                .onErrorResume(e -> {
                                        log.error("Error assigning image to widget {}: {}", widgetId, e.getMessage(),
                                                        e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01",
                                                                        "Failed to assign image to widget")));
                                });
        }

        /**
         * GET /api/builder/images/widgets/{widgetId}
         * Returns all images assigned to the widget (all roles).
         */
        @GetMapping("/widgets/{widgetId}")
        public Mono<ResponseEntity<ApiResponse<List<WidgetImageResponse>>>> getWidgetImages(
                        @PathVariable Long widgetId) {

                return imageService.getWidgetImages(widgetId)
                                .collectList()
                                .map(images -> ResponseEntity.ok(ApiResponse.success(images)))
                                .onErrorResume(e -> {
                                        log.error("Error fetching images for widget {}: {}", widgetId, e.getMessage(),
                                                        e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01",
                                                                        "Failed to fetch widget images")));
                                });
        }

        /**
         * GET /api/builder/images/widgets/{widgetId}/{role}
         * Returns the single image assigned to the widget for the given role.
         * Role values: ICON | BACKGROUND | THUMBNAIL | BANNER (case-insensitive)
         */
        @GetMapping("/widgets/{widgetId}/{role}")
        public Mono<ResponseEntity<ApiResponse<WidgetImageResponse>>> getWidgetImageByRole(
                        @PathVariable Long widgetId,
                        @PathVariable String role) {

                return imageService.getWidgetImageByRole(widgetId, role)
                                .map(image -> ResponseEntity.ok(ApiResponse.success(image)))
                                .onErrorResume(BusinessException.class,
                                                e -> {
                                                        // IMG-400-05 = invalid role value → 400 Bad Request
                                                        // IMG-404-xx = not found → 404 Not Found
                                                        HttpStatus status = e.getCode().startsWith("IMG-400")
                                                                        ? HttpStatus.BAD_REQUEST
                                                                        : HttpStatus.NOT_FOUND;
                                                        return Mono.just(ResponseEntity.status(status)
                                                                        .body(ApiResponse.error(e.getCode(), e.getMessage())));
                                                })
                                .onErrorResume(e -> {
                                        log.error("Error fetching {} image for widget {}: {}", role, widgetId,
                                                        e.getMessage(), e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01",
                                                                        "Failed to fetch widget image")));
                                });
        }

        /**
         * DELETE /api/builder/images/widgets/{widgetId}/{role}
         * Removes the role assignment from the widget (does NOT delete the image file).
         */
        @DeleteMapping("/widgets/{widgetId}/{role}")
        public Mono<ResponseEntity<ApiResponse<Void>>> removeWidgetImageRole(
                        @PathVariable Long widgetId,
                        @PathVariable String role) {

                return imageService.removeWidgetImageRole(widgetId, role)
                                .then(Mono.just(ResponseEntity.ok(ApiResponse.<Void>success(null))))
                                .onErrorResume(BusinessException.class,
                                                e -> Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                                                .body(ApiResponse.error(e.getCode(), e.getMessage()))))
                                .onErrorResume(e -> {
                                        log.error("Error removing {} role from widget {}: {}", role, widgetId,
                                                        e.getMessage(), e);
                                        return Mono.just(ResponseEntity.ok(
                                                        ApiResponse.error("IMG-500-01",
                                                                        "Failed to remove widget image role")));
                                });
        }
}
