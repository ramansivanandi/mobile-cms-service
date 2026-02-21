package com.dynamicui.repository;

import com.dynamicui.entity.WidgetImage;
import lombok.RequiredArgsConstructor;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

// Uses DatabaseClient directly because widget_images has a composite PK (widget_id, image_role)
// which Spring Data R2DBC does not support via ReactiveCrudRepository.
@Repository
@RequiredArgsConstructor
public class WidgetImageRepository {

    private final DatabaseClient databaseClient;

    /**
     * Upsert: assign (or reassign) an image to a widget for a specific role.
     * Only one image per role per widget is allowed — enforced by the composite PK.
     */
    public Mono<Void> assignImage(Long widgetId, Long imageId, String imageRole) {
        return databaseClient.sql(
                        "INSERT INTO widget_images (widget_id, image_id, image_role) " +
                        "VALUES (:widgetId, :imageId, :imageRole) " +
                        "ON CONFLICT (widget_id, image_role) DO UPDATE SET image_id = EXCLUDED.image_id")
                .bind("widgetId", widgetId)
                .bind("imageId", imageId)
                .bind("imageRole", imageRole)
                .then();
    }

    public Flux<WidgetImage> findByWidgetId(Long widgetId) {
        return databaseClient.sql(
                        "SELECT widget_id, image_id, image_role FROM widget_images WHERE widget_id = :widgetId")
                .bind("widgetId", widgetId)
                .map((row, meta) -> new WidgetImage(
                        row.get("widget_id", Long.class),
                        row.get("image_id", Long.class),
                        row.get("image_role", String.class)))
                .all();
    }

    public Mono<WidgetImage> findByWidgetIdAndRole(Long widgetId, String imageRole) {
        return databaseClient.sql(
                        "SELECT widget_id, image_id, image_role FROM widget_images " +
                        "WHERE widget_id = :widgetId AND image_role = :imageRole")
                .bind("widgetId", widgetId)
                .bind("imageRole", imageRole)
                .map((row, meta) -> new WidgetImage(
                        row.get("widget_id", Long.class),
                        row.get("image_id", Long.class),
                        row.get("image_role", String.class)))
                .one();
    }

    public Mono<Void> removeAssignment(Long widgetId, String imageRole) {
        return databaseClient.sql(
                        "DELETE FROM widget_images WHERE widget_id = :widgetId AND image_role = :imageRole")
                .bind("widgetId", widgetId)
                .bind("imageRole", imageRole)
                .then();
    }

    public Mono<Void> removeAllForWidget(Long widgetId) {
        return databaseClient.sql("DELETE FROM widget_images WHERE widget_id = :widgetId")
                .bind("widgetId", widgetId)
                .then();
    }
}
