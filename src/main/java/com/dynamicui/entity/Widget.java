package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("widget")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Widget {

    @Id
    @Column("widget_id")
    private Long widgetId;

    @Column("page_id")
    private Long pageId;

    @Column("parent_widget_id")
    private Long parentWidgetId;

    @Column("type")
    private String type;

    @Column("name")
    private String name;

    @Column("label")
    private String label;

    @Column("order_no")
    private Integer orderNo;
}
