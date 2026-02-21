package com.dynamicui.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WidgetImageAssignRequest {
    private Long imageId;
    // Must be one of: ICON, BACKGROUND, THUMBNAIL, BANNER
    private String imageRole;
}
