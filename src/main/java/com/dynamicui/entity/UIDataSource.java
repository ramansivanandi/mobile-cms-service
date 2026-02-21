package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("ui_data_source")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UIDataSource {

    @Id
    @Column("ds_id")
    private Long dsId;

    @Column("widget_id")
    private Long widgetId;

    @Column("source_type")
    private String sourceType;

    @Column("source_value")
    private String sourceValue;
}
