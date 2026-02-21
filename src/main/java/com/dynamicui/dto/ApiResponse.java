package com.dynamicui.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

        private Status status;
        private T data;

        @Data
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class Status {
                private String code;
                private String desc;

        }

        /**
         * Create a successful response
         */
        public static <T> ApiResponse<T> success(T data) {
                return ApiResponse.<T>builder()
                                .status(Status.builder()
                                                .code("000000")
                                                .desc("SUCCESS")
                                                .build())
                                .data(data)
                                .build();
        }

        /**
         * Create an error response
         */
        public static <T> ApiResponse<T> error(String code, String description) {
                return ApiResponse.<T>builder()
                                .status(Status.builder()
                                                .code(code)
                                                .desc(description)
                                                .build())
                                .data(null)
                                .build();
        }

        /**
         * Create an error response with data
         */
        public static <T> ApiResponse<T> error(String code, String description, T data) {
                return ApiResponse.<T>builder()
                                .status(Status.builder()
                                                .code(code)
                                                .desc(description)
                                                .build())
                                .data(data)
                                .build();
        }
}
