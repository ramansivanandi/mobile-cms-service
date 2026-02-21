package com.dynamicui.repository;

import org.springframework.data.repository.reactive.ReactiveCrudRepository;

import com.dynamicui.entity.WidgetPseudoStyle;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface WidgetPseudoStyleRepository
        extends ReactiveCrudRepository<WidgetPseudoStyle, Long> {

    Flux<WidgetPseudoStyle> findByWidgetId(Long widgetId);

    Flux<WidgetPseudoStyle> findByWidgetIdAndSelector(Long widgetId, String selector);

    Mono<WidgetPseudoStyle> findByPropIdAndWidgetId(Long propId, Long widgetId);

}