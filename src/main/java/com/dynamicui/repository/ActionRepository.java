package com.dynamicui.repository;

import com.dynamicui.entity.WidgetAction;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface ActionRepository extends ReactiveCrudRepository<WidgetAction, Long> {
    Flux<WidgetAction> findByWidgetIdOrderByOrderNo(Long widgetId);
}
