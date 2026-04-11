package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "staff")
@Data
public class Staff {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int staffId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String gender;

    @Temporal(TemporalType.DATE)
    private Date dob;

    private String position;
    private double salary;

    @Temporal(TemporalType.DATE)
    private Date hireDate;

    private String note;
    private int status;
    private String avatar;
}