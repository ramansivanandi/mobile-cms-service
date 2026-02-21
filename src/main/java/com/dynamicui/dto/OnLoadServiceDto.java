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
public class OnLoadServiceDto {
    private String serviceId;
    private String api;
    private String httpMethod;
    private Object payload;
    private Object headers;
    private String serviceIdentifier;
    private String onSuccess;
    private String onFailure;
}

