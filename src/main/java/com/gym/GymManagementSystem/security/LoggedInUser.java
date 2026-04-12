package com.gym.GymManagementSystem.security;

/**
 * DTO lưu session cho admin / khu vực member (JSP).
 */
public class LoggedInUser {

    private final String fullName;
    private final String roleName;
    private final String email;
    private final String phone;
    private final Long userId;

    public LoggedInUser(String fullName, String roleName) {
        this(fullName, roleName, null, null, null);
    }

    public LoggedInUser(String fullName, String roleName, String email, String phone, Long userId) {
        this.fullName = fullName;
        this.roleName = roleName;
        this.email = email;
        this.phone = phone;
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getRoleName() {
        return roleName;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public Long getUserId() {
        return userId;
    }
}
