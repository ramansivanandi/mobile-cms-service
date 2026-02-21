package com.dynamicui.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import org.springframework.data.relational.core.mapping.Column;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Data
@Table("widget_pseudo_styles")
@NoArgsConstructor
public class WidgetPseudoStyle {

    @Id
    @Column("prop_id")
    private Long propId;

    @Column("widget_id")
    @NonNull
    private Long widgetId;

    @Column("prop_key")
    @NonNull
    private String propKey;

    @Column("prop_value")
    @NonNull
    private String propValue;

    @Column("selector")
    @NonNull
    private String selector;

    @Column("remarks")
    @NonNull
    private String remarks;
}