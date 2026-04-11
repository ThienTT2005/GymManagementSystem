package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    private String username;
    private String password;
    private String status;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
}