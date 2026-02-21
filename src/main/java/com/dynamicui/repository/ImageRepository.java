package com.dynamicui.repository;

import com.dynamicui.entity.Image;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ImageRepository extends ReactiveCrudRepository<Image, Long> {
}
