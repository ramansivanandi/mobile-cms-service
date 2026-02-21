package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// Composite PK (widget_id, image_role) — managed via DatabaseClient, not Spring Data repository
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WidgetImage {
    private Long widgetId;
    private Long imageId;
    private String imageRole;
}
