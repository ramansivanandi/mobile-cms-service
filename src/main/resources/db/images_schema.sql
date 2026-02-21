-- Images table: stores metadata only, actual file is on the server filesystem
CREATE TABLE IF NOT EXISTS images (
    id           SERIAL PRIMARY KEY,
    file_name    VARCHAR(255),        -- original filename (sanitized, display only)
    content_type VARCHAR(100),        -- validated MIME type: image/jpeg, image/png, etc.
    file_size    BIGINT,              -- bytes
    file_path    TEXT,                -- UUID-based filename (relative, never full OS path)
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Widget ↔ Image join table with image role semantics
-- Composite PK enforces: one image per role per widget
CREATE TABLE IF NOT EXISTS widget_images (
    widget_id  BIGINT REFERENCES widget(widget_id) ON DELETE CASCADE,
    image_id   BIGINT REFERENCES images(id)        ON DELETE CASCADE,
    image_role VARCHAR(50),   -- ICON | BACKGROUND | THUMBNAIL | BANNER
    PRIMARY KEY (widget_id, image_role)
);

CREATE INDEX IF NOT EXISTS idx_widget_images_widget_id ON widget_images (widget_id);
CREATE INDEX IF NOT EXISTS idx_widget_images_image_id  ON widget_images (image_id);
