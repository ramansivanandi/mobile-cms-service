package com.dynamicui.repository;

import com.dynamicui.entity.OnLoadService;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface OnLoadServiceRepository extends ReactiveCrudRepository<OnLoadService, Long> {
    Flux<OnLoadService> findByPageId(Long pageId);
}
