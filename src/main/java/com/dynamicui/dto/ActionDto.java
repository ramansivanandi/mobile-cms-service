package com.dynamicui.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ActionDto {
    private String name;
    private String type;
    private String triggerEvent;
    private String httpMethod;
    private String endpointUrl;
    private Object payloadTemplate;
    private String payloadType;
    private Object headers;
    private Object queryParams;
    private String successHandler;
    private String errorHandler;
    private Integer timeout;
    private Integer order;
    private Boolean enabled;
    private String conditionExpression;
}

