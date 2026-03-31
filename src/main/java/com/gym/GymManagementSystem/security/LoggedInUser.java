package com.gym.GymManagementSystem.security;

/**
 * DTO tối giản lưu vào session để JSP admin hiển thị.
 */
public class LoggedInUser {
    private final String fullName;
    private final String roleName;

    public LoggedInUser(String fullName, String roleName) {
        this.fullName = fullName;
        this.roleName = roleName;
    }

    public String getFullName() {
        return fullName;
    }

    public String getRoleName() {
        return roleName;
    }
}

