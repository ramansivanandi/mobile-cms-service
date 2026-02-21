package com.dynamicui.dto;

import lombok.Data;

@Data
public class UpdatePseudoStyleRequest {

    private String selector;
    private String propKey;
    private String propValue;
    private String remarks;
}