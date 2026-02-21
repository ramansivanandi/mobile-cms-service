package com.dynamicui.repository;

import com.dynamicui.entity.WidgetProps;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface PropertyRepository extends ReactiveCrudRepository<WidgetProps, Long> {
    Flux<WidgetProps> findByWidgetId(Long widgetId);
}
