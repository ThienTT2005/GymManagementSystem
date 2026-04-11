package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "consultations")
@Data
public class Consultation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int consultationId;

    private String fullname;
    private String phone;
    private String email;
    private String status;
}