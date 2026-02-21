package com.dynamicui.dto;

import com.dynamicui.entity.WidgetPseudoStyle;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ComponentDto {
    private String type;
    private String label;
    private String name;
    private Integer order;
    private Map<String, String> properties;
    private List<RuleDto> rules;
    private Object dataSource;
    private List<ActionDto> actions;
    private List<ComponentDto> children; // For nested components (e.g., widgets inside a card)
    private List<WidgetPseudoStyle> pseudoStyles;
}
