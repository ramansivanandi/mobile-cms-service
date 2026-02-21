package com.dynamicui.dto;

import lombok.Data;

@Data
public class PseudoStyleDto {

    private Long widgetId;
    private String selector;
    private String propKey;
    private String propValue;
    private String remarks;
}