package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "contacts")
@Getter
@Setter
@NoArgsConstructor
public class Contact {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "contact_id")
    private Long contactId;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    private String phone;

    private String email;

    @Column(columnDefinition = "TEXT")
    private String message;

    @Column(name = "contact_date")
    private LocalDate contactDate;

    private String status;
}