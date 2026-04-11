package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "trial_requests")
@Data
public class TrialRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int trialId;

    private String fullname;
    private String phone;
    private String email;

    @Temporal(TemporalType.DATE)
    private Date preferredDate;

    private String status;
    private String note;
}