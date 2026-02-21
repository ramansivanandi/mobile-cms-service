package com.dynamicui.service;

import com.dynamicui.dto.BusinessException;
import com.dynamicui.dto.ImageUploadResponse;
import com.dynamicui.dto.WidgetImageResponse;
import com.dynamicui.entity.Image;
import com.dynamicui.entity.ImageRole;
import com.dynamicui.entity.WidgetImage;
import com.dynamicui.repository.ImageRepository;
import com.dynamicui.repository.WidgetImageRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuples;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ImageService {

    private final ImageRepository imageRepository;
    private final WidgetImageRepository widgetImageRepository;

    @Value("${app.images.upload-dir:./uploads/images}")
    private String uploadDirConfig;

    @Value("${app.images.base-url:http://localhost:8081/api/builder/images}")
    private String baseUrl;

    // Max 10 MB per image
    private static final long MAX_FILE_SIZE = 10L * 1024 * 1024;

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/gif", "image/webp", "image/svg+xml");

    private static final Map<String, String> EXTENSION_MAP = Map.of(
            "image/jpeg", ".jpg",
            "image/png",  ".png",
            "image/gif",  ".gif",
            "image/webp", ".webp",
            "image/svg+xml", ".svg");

    private Path uploadDir;

    @PostConstruct
    public void init() throws IOException {
        uploadDir = Paths.get(uploadDirConfig).toAbsolutePath().normalize();
        Files.createDirectories(uploadDir);
        log.info("Image upload directory initialized: {}", uploadDir);
    }

    // -------------------------------------------------------------------------
    // Upload
    // -------------------------------------------------------------------------

    public Mono<ImageUploadResponse> uploadImage(FilePart filePart) {
        String declaredType = filePart.headers().getContentType() != null
                ? filePart.headers().getContentType().toString().toLowerCase()
                : "";

        // Strip charset suffix if present (e.g. "image/jpeg; charset=...")
        String contentType = declaredType.contains(";")
                ? declaredType.substring(0, declaredType.indexOf(';')).trim()
                : declaredType;

        if (!ALLOWED_CONTENT_TYPES.contains(contentType)) {
            return Mono.error(new BusinessException("IMG-400-01",
                    "Unsupported image type '" + contentType + "'. Allowed: JPEG, PNG, GIF, WebP, SVG"));
        }

        String extension     = EXTENSION_MAP.getOrDefault(contentType, ".img");
        String storedName    = UUID.randomUUID() + extension;           // UUID-based, never user-supplied
        String originalName  = sanitizeFilename(filePart.filename());
        Path   targetPath    = uploadDir.resolve(storedName).normalize();

        // Path-traversal guard
        if (!targetPath.startsWith(uploadDir)) {
            return Mono.error(new BusinessException("IMG-400-02", "Invalid file path"));
        }

        final String finalContentType = contentType;

        return DataBufferUtils.join(filePart.content())
                .flatMap(dataBuffer -> {
                    byte[] bytes = new byte[dataBuffer.readableByteCount()];
                    dataBuffer.read(bytes);
                    DataBufferUtils.release(dataBuffer);

                    if (bytes.length > MAX_FILE_SIZE) {
                        return Mono.error(new BusinessException("IMG-400-03",
                                "File exceeds maximum allowed size of " + (MAX_FILE_SIZE / (1024 * 1024)) + " MB"));
                    }

                    // Magic-byte validation: file content must match declared MIME type
                    if (!hasMagicBytes(bytes, finalContentType)) {
                        return Mono.error(new BusinessException("IMG-400-04",
                                "File content does not match declared content type"));
                    }

                    long fileSize = bytes.length;

                    return Mono.fromCallable(() -> {
                                Files.write(targetPath, bytes);
                                return fileSize;
                            })
                            .subscribeOn(Schedulers.boundedElastic())
                            .flatMap(size -> {
                                Image image = new Image();
                                image.setFileName(originalName);
                                image.setContentType(finalContentType);
                                image.setFileSize(size);
                                image.setFilePath(storedName);   // relative filename only — never expose full path
                                image.setCreatedAt(LocalDateTime.now());
                                return imageRepository.save(image);
                            })
                            .map(saved -> toUploadResponse(saved));
                })
                .doOnError(e -> {
                    // Best-effort cleanup: remove the file if DB save fails
                    try { Files.deleteIfExists(targetPath); } catch (IOException ignored) {}
                });
    }

    // -------------------------------------------------------------------------
    // Metadata
    // -------------------------------------------------------------------------

    public Mono<ImageUploadResponse> getImageMetadata(Long imageId) {
        return imageRepository.findById(imageId)
                .switchIfEmpty(Mono.error(new BusinessException("IMG-404-01", "Image not found: " + imageId)))
                .map(this::toUploadResponse);
    }

    // -------------------------------------------------------------------------
    // Content (binary serving)
    // -------------------------------------------------------------------------

    public Mono<Tuple2<byte[], String>> getImageContent(Long imageId) {
        return imageRepository.findById(imageId)
                .switchIfEmpty(Mono.error(new BusinessException("IMG-404-01", "Image not found: " + imageId)))
                .flatMap(image -> {
                    Path filePath = uploadDir.resolve(image.getFilePath()).normalize();

                    // Path-traversal guard on read
                    if (!filePath.startsWith(uploadDir)) {
                        return Mono.error(new BusinessException("IMG-403-01", "Access denied"));
                    }

                    return Mono.fromCallable(() -> Files.readAllBytes(filePath))
                            .subscribeOn(Schedulers.boundedElastic())
                            .map(bytes -> Tuples.of(bytes, image.getContentType()));
                });
    }

    // -------------------------------------------------------------------------
    // Widget ↔ Image assignment
    // -------------------------------------------------------------------------

    public Mono<Void> assignImageToWidget(Long widgetId, Long imageId, String imageRole) {
        if (!ImageRole.isValid(imageRole)) {
            return Mono.error(new BusinessException("IMG-400-05",
                    "Invalid image role '" + imageRole + "'. Must be one of: ICON, BACKGROUND, THUMBNAIL, BANNER"));
        }
        String role = imageRole.toUpperCase();
        return imageRepository.findById(imageId)
                .switchIfEmpty(Mono.error(new BusinessException("IMG-404-01", "Image not found: " + imageId)))
                .flatMap(image -> widgetImageRepository.assignImage(widgetId, imageId, role));
    }

    public Flux<WidgetImageResponse> getWidgetImages(Long widgetId) {
        return widgetImageRepository.findByWidgetId(widgetId)
                .flatMap(wi -> imageRepository.findById(wi.getImageId())
                        .map(image -> toWidgetImageResponse(wi, image)));
    }

    public Mono<WidgetImageResponse> getWidgetImageByRole(Long widgetId, String imageRole) {
        if (!ImageRole.isValid(imageRole)) {
            return Mono.error(new BusinessException("IMG-400-05",
                    "Invalid image role '" + imageRole + "'. Must be one of: ICON, BACKGROUND, THUMBNAIL, BANNER"));
        }
        String role = imageRole.toUpperCase();
        return widgetImageRepository.findByWidgetIdAndRole(widgetId, role)
                .switchIfEmpty(Mono.error(new BusinessException("IMG-404-02",
                        "No " + role + " image assigned to widget " + widgetId)))
                .flatMap(wi -> imageRepository.findById(wi.getImageId())
                        .map(image -> toWidgetImageResponse(wi, image)));
    }

    public Mono<Void> removeWidgetImageRole(Long widgetId, String imageRole) {
        if (!ImageRole.isValid(imageRole)) {
            return Mono.error(new BusinessException("IMG-400-05",
                    "Invalid image role '" + imageRole + "'. Must be one of: ICON, BACKGROUND, THUMBNAIL, BANNER"));
        }
        return widgetImageRepository.removeAssignment(widgetId, imageRole.toUpperCase());
    }

    // -------------------------------------------------------------------------
    // Delete
    // -------------------------------------------------------------------------

    public Mono<Void> deleteImage(Long imageId) {
        return imageRepository.findById(imageId)
                .switchIfEmpty(Mono.error(new BusinessException("IMG-404-01", "Image not found: " + imageId)))
                .flatMap(image -> {
                    Path filePath = uploadDir.resolve(image.getFilePath()).normalize();
                    // DB delete first (widget_images rows cascade automatically)
                    return imageRepository.deleteById(imageId)
                            .then(Mono.fromCallable(() -> {
                                Files.deleteIfExists(filePath);
                                return true;
                            }).subscribeOn(Schedulers.boundedElastic()))
                            .then();
                });
    }

    // -------------------------------------------------------------------------
    // Security helpers
    // -------------------------------------------------------------------------

    /**
     * Validates file magic bytes against the declared MIME type.
     * Prevents disguised uploads (e.g., an .exe renamed to .jpg).
     */
    private boolean hasMagicBytes(byte[] bytes, String contentType) {
        if (bytes.length < 4) return false;

        switch (contentType) {
            case "image/jpeg":
                // FF D8 FF
                return bytes[0] == (byte) 0xFF && bytes[1] == (byte) 0xD8 && bytes[2] == (byte) 0xFF;

            case "image/png":
                // 89 50 4E 47 0D 0A 1A 0A
                return bytes[0] == (byte) 0x89 && bytes[1] == 0x50
                        && bytes[2] == 0x4E && bytes[3] == 0x47;

            case "image/gif":
                // GIF87a or GIF89a
                return bytes[0] == 0x47 && bytes[1] == 0x49
                        && bytes[2] == 0x46 && bytes[3] == 0x38;

            case "image/webp":
                // RIFF....WEBP
                if (bytes.length < 12) return false;
                return bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46
                        && bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50;

            case "image/svg+xml":
                // SVG is XML text — check for <?xml or <svg prefix
                String head = new String(Arrays.copyOf(bytes, Math.min(bytes.length, 30))).trim();
                return head.startsWith("<?xml") || head.startsWith("<svg") || head.startsWith("<!DOCTYPE svg");

            default:
                return false;
        }
    }

    /** Strip path separators and null bytes from the original filename. */
    private String sanitizeFilename(String filename) {
        if (filename == null || filename.isBlank()) return "upload";
        return filename.replaceAll("[/\\\\:*?\"<>|\\x00]", "_");
    }

    // -------------------------------------------------------------------------
    // Mappers
    // -------------------------------------------------------------------------

    private ImageUploadResponse toUploadResponse(Image image) {
        return ImageUploadResponse.builder()
                .imageId(image.getId())
                .fileName(image.getFileName())
                .contentType(image.getContentType())
                .fileSize(image.getFileSize())
                .imageUrl(baseUrl + "/" + image.getId() + "/content")
                .createdAt(image.getCreatedAt())
                .build();
    }

    private WidgetImageResponse toWidgetImageResponse(WidgetImage wi, Image image) {
        return WidgetImageResponse.builder()
                .imageId(image.getId())
                .widgetId(wi.getWidgetId())
                .imageRole(wi.getImageRole())
                .fileName(image.getFileName())
                .contentType(image.getContentType())
                .fileSize(image.getFileSize())
                .imageUrl(baseUrl + "/" + image.getId() + "/content")
                .createdAt(image.getCreatedAt())
                .build();
    }
}
