package com.dynamicui.exception;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.dto.BusinessException;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import reactor.core.publisher.Mono;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

        @ExceptionHandler(BusinessException.class)
        public Mono<ResponseEntity<ApiResponse<Object>>> handleBusinessException(
                        BusinessException ex) {

                return Mono.just(
                                ResponseEntity.badRequest()
                                                .body(ApiResponse.error(ex.getCode(), ex.getMessage())));
        }

        @ExceptionHandler(Exception.class)
        public Mono<ResponseEntity<ApiResponse<Object>>> handleGenericException(
                        Exception ex) {
                log.error("Exception:{}", ex);

                return Mono.just(
                                ResponseEntity.internalServerError()
                                                .body(ApiResponse.error("99999", "TEST Internal Server Error")));
        }
}