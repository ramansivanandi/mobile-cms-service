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

    Mono<WidgetPseudoStyle> findByPropIdAndWidgetIdAndPropKey(Long propId, Long widgetId, String propKey);

    Mono<WidgetPseudoStyle> findByPropIdAndWidgetIdAndSelector(String propId, String widgetId, String selector);

}