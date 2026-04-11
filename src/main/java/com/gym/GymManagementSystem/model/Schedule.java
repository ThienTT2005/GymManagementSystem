package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalTime;

@Entity
@Table(name = "schedules")
@Data
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int scheduleId;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private GymClass gymClass;

    private String dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private int status;
}