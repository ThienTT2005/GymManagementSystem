package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data               // Lombok: tự tạo getter, setter, toString, equals
@NoArgsConstructor  // Lombok: tự tạo constructor rỗng (JPA bắt buộc phải có)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // AUTO_INCREMENT
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @Column(name = "email", unique = true, length = 100)
    private String email;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "role_id")
    private Integer roleId;

    @Column(name = "status", length = 20)
    private String status = "active";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist // Tự động set thời gian khi INSERT
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
    }

    // Constructor 5 tham số để tương thích với AuthController
    public User(String username, String password, String fullName, String email, Integer roleId) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.roleId = roleId;
        this.status = "active";
    }
}