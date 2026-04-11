package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "trainers")
@Data
public class Trainer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int trainerId;

    @ManyToOne
    @JoinColumn(name = "staff_id")
    private Staff staff;

    private String specialty;
    private int experience;
    private String certifications;
    private String photo;
    private int status;
}