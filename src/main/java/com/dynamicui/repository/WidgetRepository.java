package com.dynamicui.repository;

import com.dynamicui.entity.Widget;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface WidgetRepository extends ReactiveCrudRepository<Widget, Long> {
    Flux<Widget> findByPageIdOrderByOrderNo(Long pageId);
    Flux<Widget> findByPageIdAndParentWidgetIdIsNullOrderByOrderNo(Long pageId);
    Flux<Widget> findByParentWidgetIdOrderByOrderNo(Long parentWidgetId);
}
