package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("page")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Page {

    @Id
    @Column("page_id")
    private Long pageId;

    @Column("category_id")
    private Long categoryId;

    @Column("title")
    private String title;

    @Column("order_no")
    private Integer orderNo;

    @Column("layout_type")
    private String layoutType;

    @Column("columns_per_row")
    private Integer columnsPerRow;
}
