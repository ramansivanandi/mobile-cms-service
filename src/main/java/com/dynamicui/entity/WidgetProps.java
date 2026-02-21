package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("widget_props")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WidgetProps {

    @Id
    @Column("prop_id")
    private Long propId;

    @Column("widget_id")
    private Long widgetId;

    @Column("prop_key")
    private String propKey;

    @Column("prop_value")
    private String propValue;
}
