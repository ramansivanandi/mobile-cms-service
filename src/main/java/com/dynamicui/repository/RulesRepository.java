package com.dynamicui.repository;

import com.dynamicui.entity.WidgetRule;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface RulesRepository extends ReactiveCrudRepository<WidgetRule, Long> {
    Flux<WidgetRule> findByWidgetId(Long widgetId);
}
