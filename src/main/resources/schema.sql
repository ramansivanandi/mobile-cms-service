-- =====================================================================
-- PostgreSQL Schema for Dynamic UI Configuration (R2DBC)
-- Run this ONCE against your local PostgreSQL database.
-- Creates all tables, sequences, indexes, and sets DEFAULT nextval().
-- =====================================================================

-- Create PRODUCT table
CREATE TABLE IF NOT EXISTS product (
    product_id BIGINT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(500)
);

-- Create CATEGORY table
CREATE TABLE IF NOT EXISTS category (
    category_id BIGINT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    name VARCHAR(200) DEFAULT 'N/A' NOT NULL,
    description VARCHAR(500),
    CONSTRAINT fk_category_product FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

-- Create PAGE table
CREATE TABLE IF NOT EXISTS page (
    page_id BIGINT PRIMARY KEY,
    category_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    order_no INTEGER NOT NULL,
    layout_type VARCHAR(20),
    columns_per_row INTEGER,
    CONSTRAINT fk_page_category FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-- Create WIDGET table
CREATE TABLE IF NOT EXISTS widget (
    widget_id BIGINT PRIMARY KEY,
    page_id BIGINT NOT NULL,
    parent_widget_id BIGINT,
    type VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    label VARCHAR(200),
    order_no INTEGER NOT NULL,
    CONSTRAINT fk_widget_page FOREIGN KEY (page_id) REFERENCES page(page_id) ON DELETE CASCADE,
    CONSTRAINT fk_widget_parent FOREIGN KEY (parent_widget_id) REFERENCES widget(widget_id) ON DELETE CASCADE
);

-- Create WIDGET_PROPS table
CREATE TABLE IF NOT EXISTS widget_props (
    prop_id BIGINT PRIMARY KEY,
    widget_id BIGINT NOT NULL,
    prop_key VARCHAR(100) NOT NULL,
    prop_value TEXT,
    CONSTRAINT fk_props_widget FOREIGN KEY (widget_id) REFERENCES widget(widget_id) ON DELETE CASCADE
);

-- Create WIDGET_RULE table
CREATE TABLE IF NOT EXISTS widget_rule (
    rule_id BIGINT PRIMARY KEY,
    widget_id BIGINT NOT NULL,
    rule_type VARCHAR(100) NOT NULL,
    rule_expression VARCHAR(500),
    CONSTRAINT fk_rule_widget FOREIGN KEY (widget_id) REFERENCES widget(widget_id) ON DELETE CASCADE
);

-- Create UI_DATA_SOURCE table
CREATE TABLE IF NOT EXISTS ui_data_source (
    ds_id BIGINT PRIMARY KEY,
    widget_id BIGINT NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    source_value VARCHAR(1000),
    CONSTRAINT fk_datasource_widget FOREIGN KEY (widget_id) REFERENCES widget(widget_id) ON DELETE CASCADE
);

-- Create WIDGET_ACTION table
CREATE TABLE IF NOT EXISTS widget_action (
    action_id BIGINT PRIMARY KEY,
    widget_id BIGINT NOT NULL,
    action_name VARCHAR(100) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    trigger_event VARCHAR(50) DEFAULT 'click',
    http_method VARCHAR(10),
    endpoint_url VARCHAR(1000),
    payload_template JSONB,
    payload_type VARCHAR(20) DEFAULT 'dynamic',
    headers JSONB,
    query_params JSONB,
    success_handler VARCHAR(500),
    error_handler VARCHAR(500),
    timeout_ms INTEGER DEFAULT 30000,
    order_no INTEGER DEFAULT 1,
    is_enabled CHAR(1) DEFAULT 'Y',
    condition_expression VARCHAR(500),
    CONSTRAINT fk_action_widget FOREIGN KEY (widget_id) REFERENCES widget(widget_id) ON DELETE CASCADE
);

-- Create ON_LOAD_SERVICE table
CREATE TABLE IF NOT EXISTS on_load_service (
    on_load_service_id BIGINT PRIMARY KEY,
    page_id BIGINT NOT NULL,
    service_id VARCHAR(100) NOT NULL,
    api VARCHAR(1000) NOT NULL,
    http_method VARCHAR(10) NOT NULL,
    payload JSONB,
    headers JSONB,
    service_identifier VARCHAR(100),
    on_success VARCHAR(500),
    on_failure VARCHAR(500),
    CONSTRAINT fk_onload_page FOREIGN KEY (page_id) REFERENCES page(page_id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_category_product_id ON category(product_id);
CREATE INDEX IF NOT EXISTS idx_page_category_id ON page(category_id);
CREATE INDEX IF NOT EXISTS idx_widget_page_id ON widget(page_id);
CREATE INDEX IF NOT EXISTS idx_props_widget_id ON widget_props(widget_id);
CREATE INDEX IF NOT EXISTS idx_rule_widget_id ON widget_rule(widget_id);
CREATE INDEX IF NOT EXISTS idx_datasource_widget_id ON ui_data_source(widget_id);
CREATE INDEX IF NOT EXISTS idx_action_widget_id ON widget_action(widget_id);
CREATE INDEX IF NOT EXISTS idx_onload_page_id ON on_load_service(page_id);

-- =====================================================================
-- Sequences + DEFAULT nextval() for R2DBC auto-ID generation
-- =====================================================================

CREATE SEQUENCE IF NOT EXISTS seq_product_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_category_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_page_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_widget_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_prop_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_rule_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_ds_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_action_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_on_load_service_id START WITH 1 INCREMENT BY 1;

-- Sync sequences to current max PK values (safe even on empty tables)
SELECT setval('seq_product_id', COALESCE((SELECT MAX(product_id) FROM product), 0) + 1, false);
SELECT setval('seq_category_id', COALESCE((SELECT MAX(category_id) FROM category), 0) + 1, false);
SELECT setval('seq_page_id', COALESCE((SELECT MAX(page_id) FROM page), 0) + 1, false);
SELECT setval('seq_widget_id', COALESCE((SELECT MAX(widget_id) FROM widget), 0) + 1, false);
SELECT setval('seq_prop_id', COALESCE((SELECT MAX(prop_id) FROM widget_props), 0) + 1, false);
SELECT setval('seq_rule_id', COALESCE((SELECT MAX(rule_id) FROM widget_rule), 0) + 1, false);
SELECT setval('seq_ds_id', COALESCE((SELECT MAX(ds_id) FROM ui_data_source), 0) + 1, false);
SELECT setval('seq_action_id', COALESCE((SELECT MAX(action_id) FROM widget_action), 0) + 1, false);
SELECT setval('seq_on_load_service_id', COALESCE((SELECT MAX(on_load_service_id) FROM on_load_service), 0) + 1, false);

-- Set DEFAULT nextval() on each PK column (only if not already an identity column)
-- Note: If columns are GENERATED ALWAYS AS IDENTITY, the DEFAULT statements will be skipped by the database
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='product' AND column_name='product_id' AND is_identity='YES') THEN
    ALTER TABLE product ALTER COLUMN product_id SET DEFAULT nextval('seq_product_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='category' AND column_name='category_id' AND is_identity='YES') THEN
    ALTER TABLE category ALTER COLUMN category_id SET DEFAULT nextval('seq_category_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='page' AND column_name='page_id' AND is_identity='YES') THEN
    ALTER TABLE page ALTER COLUMN page_id SET DEFAULT nextval('seq_page_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='widget' AND column_name='widget_id' AND is_identity='YES') THEN
    ALTER TABLE widget ALTER COLUMN widget_id SET DEFAULT nextval('seq_widget_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='widget_props' AND column_name='prop_id' AND is_identity='YES') THEN
    ALTER TABLE widget_props ALTER COLUMN prop_id SET DEFAULT nextval('seq_prop_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='widget_rule' AND column_name='rule_id' AND is_identity='YES') THEN
    ALTER TABLE widget_rule ALTER COLUMN rule_id SET DEFAULT nextval('seq_rule_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='ui_data_source' AND column_name='ds_id' AND is_identity='YES') THEN
    ALTER TABLE ui_data_source ALTER COLUMN ds_id SET DEFAULT nextval('seq_ds_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='widget_action' AND column_name='action_id' AND is_identity='YES') THEN
    ALTER TABLE widget_action ALTER COLUMN action_id SET DEFAULT nextval('seq_action_id');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='on_load_service' AND column_name='on_load_service_id' AND is_identity='YES') THEN
    ALTER TABLE on_load_service ALTER COLUMN on_load_service_id SET DEFAULT nextval('seq_on_load_service_id');
  END IF;
END $$;
