package com.gym.GymManagementSystem.model;
import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "class_registrations")
@Data
public class ClassRegistration {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "class_registration_id")
    private int classRegistrationId;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private GymClass gymClass;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service service;

    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Temporal(TemporalType.DATE)
    private Date registrationDate;

    private int status;
    private String note;
}