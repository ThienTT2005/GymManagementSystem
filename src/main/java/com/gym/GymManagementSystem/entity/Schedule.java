package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "schedules")
@Getter
@Setter
@NoArgsConstructor
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "schedule_id")
    private Long scheduleId;

    @Column(name = "class_name", nullable = false)
    private String className;

    @Column(name = "trainer_name")
    private String trainerName;

    @Column(name = "branch_name")
    private String branchName;

    @Column(name = "schedule_date")
    private LocalDate scheduleDate;

    @Column(name = "schedule_time")
    private String scheduleTime;

    private String status;
}