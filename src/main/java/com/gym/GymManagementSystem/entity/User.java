package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false, unique = true, length = 100)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    /**
     * DB: TINYINT — 1 = hoạt động, 0 = khóa
     */
    @Column(name = "status")
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private Integer statusCode = 1;

    public Integer getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
    }

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", nullable = false)
    private Role roleEntity;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Member member;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Staff staff;

    /**
     * Form binding (admin) — không map cột; đồng bộ sang members/staff khi lưu.
     */
    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private String fullName;

    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private String email;

    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private String phone;

    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private String avatar;

    @Transient
    private String pendingRoleName;

    public String getRole() {
        return roleEntity != null ? roleEntity.getRoleName() : null;
    }

    public void setRole(String roleName) {
        this.pendingRoleName = roleName;
    }

    public String getStatus() {
        return statusCode != null && statusCode == 1 ? "Hoạt động" : "Khóa";
    }

    public void setStatus(String label) {
        if (label == null || label.isBlank()) {
            this.statusCode = 1;
            return;
        }
        if ("Hoạt động".equalsIgnoreCase(label) || "active".equalsIgnoreCase(label)) {
            this.statusCode = 1;
        } else {
            this.statusCode = 0;
        }
    }

    public String getFullName() {
        if (fullName != null && !fullName.isBlank()) {
            return fullName;
        }
        if (member != null && member.getFullname() != null && !member.getFullname().isBlank()) {
            return member.getFullname();
        }
        if (staff != null && staff.getFullName() != null && !staff.getFullName().isBlank()) {
            return staff.getFullName();
        }
        return username != null ? username : "";
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        if (email != null && !email.isBlank()) {
            return email;
        }
        if (member != null && member.getEmail() != null) {
            return member.getEmail();
        }
        if (staff != null && staff.getEmail() != null) {
            return staff.getEmail();
        }
        return null;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        if (phone != null && !phone.isBlank()) {
            return phone;
        }
        if (member != null && member.getPhone() != null) {
            return member.getPhone();
        }
        if (staff != null && staff.getPhone() != null) {
            return staff.getPhone();
        }
        return null;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        if (avatar != null && !avatar.isBlank()) {
            return avatar;
        }
        if (member != null && member.getAvatar() != null) {
            return member.getAvatar();
        }
        if (staff != null && staff.getAvatar() != null) {
            return staff.getAvatar();
        }
        return null;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public LocalDate getCreatedDate() {
        return createdAt != null ? createdAt.toLocalDate() : null;
    }

    public void setCreatedDate(LocalDate ignored) {
        // Cột created_at do DB quản lý
    }

    public boolean isActiveAccount() {
        return statusCode == null || statusCode == 1;
    }
}
