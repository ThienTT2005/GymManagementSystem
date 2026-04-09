package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "class_members")
public class ClassMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "class_member_id")
    private Integer classMemberId;

    @ManyToOne
    @JoinColumn(name = "class_id", nullable = false)
    private GymClass gymClass;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "joined_at", nullable = false)
    private LocalDate joinedAt;

    public Integer getClassMemberId() {
        return classMemberId;
    }

    public void setClassMemberId(Integer classMemberId) {
        this.classMemberId = classMemberId;
    }

    public GymClass getGymClass() {
        return gymClass;
    }

    public void setGymClass(GymClass gymClass) {
        this.gymClass = gymClass;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public LocalDate getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDate joinedAt) {
        this.joinedAt = joinedAt;
    }
}