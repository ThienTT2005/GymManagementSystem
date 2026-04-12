package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "packages")
@Getter
@Setter
@NoArgsConstructor
public class GymPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    private Long packageId;

    @Column(name = "package_name", nullable = false, length = 100)
    private String packageName;

    @Column(name = "price", nullable = false)
    private BigDecimal price;

    @Column(name = "duration_days")
    private Integer durationDays;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image")
    private String image;

    @Column(name = "status")
    private Byte status = 1;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}