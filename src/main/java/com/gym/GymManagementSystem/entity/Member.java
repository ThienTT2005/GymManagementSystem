package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "members")
@Getter
@Setter
@NoArgsConstructor
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long memberId;

    @Column(name = "fullname", nullable = false, length = 100)
    private String fullname;

    @Column(length = 20)
    private String phone;

    @Column(length = 100)
    private String email;

    @Column(length = 255)
    private String address;

    @Column(length = 20)
    private String gender;

    private LocalDate dob;

    private Integer status = 1;

    @Column(length = 255)
    private String avatar;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", unique = true)
    private User user;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;
}
