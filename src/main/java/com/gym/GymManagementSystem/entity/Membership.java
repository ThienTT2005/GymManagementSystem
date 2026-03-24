package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "memberships")
@Getter
@Setter
@NoArgsConstructor
public class Membership {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "membership_id")
    private Long membershipId;

    @Column(name = "member_name", nullable = false)
    private String memberName;

    @Column(name = "package_name", nullable = false)
    private String packageName;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    private String status;
}