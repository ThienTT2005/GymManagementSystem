package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @NotBlank(message = "Username không được để trống")
    @Column(name = "username", nullable = false, unique = true, length = 100)
    private String username;

    @NotBlank(message = "Password không được để trống")
    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "status", nullable = false)
    private Integer status = 1;

    @Column(name = "avatar", length = 255)
    private String avatar;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Member member;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Staff staff;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    @Transient
    public Integer getRoleId() {
        return role != null ? role.getRoleId() : null;
    }

    public void setRoleId(Integer roleId) {
        if (roleId == null) {
            this.role = null;
            return;
        }
        if (this.role == null) {
            this.role = new Role();
        }
        this.role.setRoleId(roleId);
    }

    @Transient
    public String getRoleName() {
        return role != null ? role.getRoleName() : null;
    }

    public void setRoleName(String roleName) {
        if (roleName == null || roleName.isBlank()) {
            if (this.role != null) {
                this.role.setRoleName(null);
            }
            return;
        }
        if (this.role == null) {
            this.role = new Role();
        }
        this.role.setRoleName(roleName.trim().toUpperCase());
    }

    @Transient
    public String getFullName() {
        if (staff != null && staff.getFullName() != null && !staff.getFullName().isBlank()) {
            return staff.getFullName();
        }
        if (member != null && member.getFullname() != null && !member.getFullname().isBlank()) {
            return member.getFullname();
        }
        return username;
    }

    @Transient
    public String getDisplayName() {
        String fullName = getFullName();
        return (fullName == null || fullName.isBlank()) ? username : fullName;
    }

    @Transient
    public String getEmail() {
        if (staff != null && staff.getEmail() != null && !staff.getEmail().isBlank()) {
            return staff.getEmail();
        }
        if (member != null && member.getEmail() != null && !member.getEmail().isBlank()) {
            return member.getEmail();
        }
        return null;
    }

    @Transient
    public String getPhone() {
        if (staff != null && staff.getPhone() != null && !staff.getPhone().isBlank()) {
            return staff.getPhone();
        }
        if (member != null && member.getPhone() != null && !member.getPhone().isBlank()) {
            return member.getPhone();
        }
        return null;
    }

    @Transient
    public String getAddress() {
        if (staff != null && staff.getAddress() != null && !staff.getAddress().isBlank()) {
            return staff.getAddress();
        }
        if (member != null && member.getAddress() != null && !member.getAddress().isBlank()) {
            return member.getAddress();
        }
        return null;
    }

    @Transient
    public String getAvatarOrDefault() {
        return (avatar == null || avatar.isBlank()) ? "default-avatar.png" : avatar;
    }
}
