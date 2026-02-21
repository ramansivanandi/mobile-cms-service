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
public class WidgetImageResponse {
    private Long imageId;
    private Long widgetId;
    private String imageRole;
    private String fileName;
    private String contentType;
    private Long fileSize;
    private String imageUrl;
    private LocalDateTime createdAt;
}
