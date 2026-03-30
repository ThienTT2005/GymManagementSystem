package com.gym.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userId;

    private String username;
    private String password;
    private String fullName;
    private String status;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // getter setter
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
}