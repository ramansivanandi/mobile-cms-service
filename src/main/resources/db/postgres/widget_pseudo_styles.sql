CREATE TABLE widget_pseudo_styles (
    prop_id        BIGSERIAL PRIMARY KEY,
    widget_id      BIGINT NOT NULL,
    prop_key       VARCHAR(255) NOT NULL,
    prop_value     TEXT NOT NULL,
    selector       VARCHAR(100) NOT NULL,
    remarks       VARCHAR(100) NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_widget
        FOREIGN KEY (widget_id)
        REFERENCES widget(widget_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_widget_pseudo_styles_widget_id
ON widget_pseudo_styles(widget_id);

CREATE INDEX idx_widget_pseudo_styles_selector
ON widget_pseudo_styles(selector);