package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "trial_registrations")
@Getter
@Setter
@NoArgsConstructor
public class TrialRegistration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "trial_id")
    private Long trialId;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(nullable = false)
    private String phone;

    private String email;

    @Column(name = "branch_name")
    private String branchName;

    @Column(name = "register_date")
    private LocalDate registerDate;

    private String status;
}