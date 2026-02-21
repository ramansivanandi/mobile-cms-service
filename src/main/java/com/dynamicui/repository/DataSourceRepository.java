package com.dynamicui.repository;

import com.dynamicui.entity.UIDataSource;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface DataSourceRepository extends ReactiveCrudRepository<UIDataSource, Long> {
    Flux<UIDataSource> findByWidgetId(Long widgetId);
}
