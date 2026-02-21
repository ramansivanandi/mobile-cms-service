package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("widget_action")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WidgetAction {

    @Id
    @Column("action_id")
    private Long actionId;

    @Column("widget_id")
    private Long widgetId;

    @Column("action_name")
    private String actionName;

    @Column("action_type")
    private String actionType;

    @Column("trigger_event")
    private String triggerEvent;

    @Column("http_method")
    private String httpMethod;

    @Column("endpoint_url")
    private String endpointUrl;

    @Column("payload_template")
    private String payloadTemplate;

    @Column("payload_type")
    private String payloadType;

    @Column("headers")
    private String headers;

    @Column("query_params")
    private String queryParams;

    @Column("success_handler")
    private String successHandler;

    @Column("error_handler")
    private String errorHandler;

    @Column("timeout_ms")
    private Integer timeoutMs;

    @Column("order_no")
    private Integer orderNo;

    @Column("is_enabled")
    private String isEnabled;

    @Column("condition_expression")
    private String conditionExpression;
}
