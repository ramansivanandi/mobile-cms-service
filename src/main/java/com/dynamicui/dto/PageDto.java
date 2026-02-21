package com.dynamicui.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PageDto {
    private String title;
    private Integer order;
    private String layoutType; // 'vertical' or 'horizontal'
    private Integer columnsPerRow; // Number of columns per row (for horizontal layout)
    private List<ComponentDto> components;
    private List<OnLoadServiceDto> onLoadServices;
}

