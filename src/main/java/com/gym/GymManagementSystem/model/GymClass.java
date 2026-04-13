package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

@Entity
@Table(name = "classes")
public class GymClass {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "class_id")
    private Integer classId;

    @NotBlank(message = "Tên lớp không được để trống")
    @Column(name = "class_name", nullable = false, length = 150)
    private String className;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id")
    private ServiceGym service;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trainer_id")
    private Trainer trainer;

    @NotNull(message = "Số lượng tối đa không được để trống")
    @Min(value = 1, message = "Số lượng tối đa phải lớn hơn 0")
    @Column(name = "max_member", nullable = false)
    private Integer maxMember;

    @Column(name = "current_member", nullable = false)
    private Integer currentMember = 0;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "status", nullable = false)
    private Integer status = 1;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public Integer getClassId() {
        return classId;
    }

    public void setClassId(Integer classId) {
        this.classId = classId;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public ServiceGym getService() {
        return service;
    }

    public void setService(ServiceGym service) {
        this.service = service;
    }

    public Trainer getTrainer() {
        return trainer;
    }

    public void setTrainer(Trainer trainer) {
        this.trainer = trainer;
    }

    public Integer getMaxMember() {
        return maxMember;
    }

    public void setMaxMember(Integer maxMember) {
        this.maxMember = maxMember;
    }

    public Integer getCurrentMember() {
        return currentMember;
    }

    public void setCurrentMember(Integer currentMember) {
        this.currentMember = currentMember;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }


    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        if (this.createdAt == null) {
            this.createdAt = now;
        }
        this.updatedAt = now;
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    @Transient
    public String getTrainerName() {
        if (trainer == null) {
            return "";
        }
        if (trainer.getStaff() != null && trainer.getStaff().getFullName() != null) {
            return trainer.getStaff().getFullName();
        }
        return "Trainer #" + trainer.getTrainerId();
    }
}
