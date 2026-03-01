package com.dynamicui.exception;

import com.dynamicui.dto.ApiResponse;
import com.dynamicui.dto.BusinessException;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.reactive.resource.NoResourceFoundException;
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

        /**
         * NoResourceFoundException is a normal 404 raised by Spring WebFlux when a
         * static resource (e.g. favicon.ico) is not found. It must NOT be logged as an
         * error and must not be caught by the generic handler below.
         */
        @ExceptionHandler(NoResourceFoundException.class)
        public Mono<ResponseEntity<ApiResponse<Object>>> handleNoResourceFound(
                        NoResourceFoundException ex) {

                return Mono.just(
                                ResponseEntity.status(HttpStatus.NOT_FOUND)
                                                .body(ApiResponse.error("404", ex.getMessage())));
        }

        @ExceptionHandler(Exception.class)
        public Mono<ResponseEntity<ApiResponse<Object>>> handleGenericException(
                        Exception ex) {
                log.error("Exception:{}", ex);

                return Mono.just(
                                ResponseEntity.internalServerError()
                                                .body(ApiResponse.error("99999", "Internal Server Error")));
        }
}
