package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "members")
@Data
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int memberId;

    private String fullname;
    private String phone;
    private String email;
    private String address;
    private String gender;

    @Temporal(TemporalType.DATE)
    private Date dob;

    private int status;
    private String avatar;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}