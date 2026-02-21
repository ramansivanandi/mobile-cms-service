CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255),
    content_type VARCHAR(100),
    file_size BIGINT,
    file_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE widget_images (
    widget_id BIGINT REFERENCES widget(widget_id) ON DELETE CASCADE,
    image_id BIGINT REFERENCES images(id) ON DELETE CASCADE,
    image_role VARCHAR(50),  -- ICON, BACKGROUND, THUMBNAIL, BANNER
    PRIMARY KEY (widget_id, image_role)
);

-- images
CREATE INDEX idx_images_created_at
ON images (created_at DESC);

-- widget_images
CREATE INDEX idx_widget_images_image_id
ON widget_images (image_id);
