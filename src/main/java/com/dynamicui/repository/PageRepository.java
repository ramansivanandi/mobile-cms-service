package com.dynamicui.repository;

import com.dynamicui.entity.Page;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface PageRepository extends ReactiveCrudRepository<Page, Long> {
    Flux<Page> findByCategoryId(Long categoryId);
}
