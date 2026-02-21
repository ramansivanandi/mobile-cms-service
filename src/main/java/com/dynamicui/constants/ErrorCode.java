package com.dynamicui.constants;

public enum ErrorCode {

    PSEUDO_STYLE_NOT_FOUND("10002", "Pseudo style not found"),
    INTERNAL_ERROR("99999", "Internal Server Error Message");

    private final String code;
    private final String message;

    ErrorCode(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public String code() {
        return code;
    }

    public String message() {
        return message;
    }
}