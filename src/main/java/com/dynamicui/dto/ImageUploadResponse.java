package com.dynamicui.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageUploadResponse {
    private Long imageId;
    private String fileName;
    private String contentType;
    private Long fileSize;
    private String imageUrl;
    private LocalDateTime createdAt;
}
