package com.gym.GymManagementSystem.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity 
@Table(name = "users") 
@Data 
@NoArgsConstructor 
@AllArgsConstructor 
public class User {

    @Id 
    private String username;

    private String password;

    @Column(name = "full_name") 
    private String fullName;

    private String email;

    @Column(name = "role_id") 
    private int roleId;
}