package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("widget_rule")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WidgetRule {

    @Id
    @Column("rule_id")
    private Long ruleId;

    @Column("widget_id")
    private Long widgetId;

    @Column("rule_type")
    private String ruleType;

    @Column("rule_expression")
    private String ruleExpression;
}
