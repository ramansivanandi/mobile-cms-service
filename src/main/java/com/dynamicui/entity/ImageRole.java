package com.dynamicui.entity;

public enum ImageRole {
    ICON, BACKGROUND, THUMBNAIL, BANNER;

    public static boolean isValid(String role) {
        if (role == null) return false;
        for (ImageRole r : values()) {
            if (r.name().equalsIgnoreCase(role)) return true;
        }
        return false;
    }
}
