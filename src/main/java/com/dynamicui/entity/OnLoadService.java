package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("on_load_service")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OnLoadService {

    @Id
    @Column("on_load_service_id")
    private Long onLoadServiceId;

    @Column("page_id")
    private Long pageId;

    @Column("service_id")
    private String serviceId;

    @Column("api")
    private String api;

    @Column("http_method")
    private String httpMethod;

    @Column("payload")
    private String payload;

    @Column("headers")
    private String headers;

    @Column("service_identifier")
    private String serviceIdentifier;

    @Column("on_success")
    private String onSuccess;

    @Column("on_failure")
    private String onFailure;
}
