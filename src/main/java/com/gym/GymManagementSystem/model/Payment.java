package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "payments")
@Data
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int paymentId;

    @ManyToOne
    @JoinColumn(name = "membership_id")
    private Membership membership;

    @ManyToOne
    @JoinColumn(name = "class_registration_id")
    private ClassRegistration classRegistration;

    private double amount;
    private String paymentMethod;

    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentDate;

    private String proofImage;
    private String status;
    private String note;
}