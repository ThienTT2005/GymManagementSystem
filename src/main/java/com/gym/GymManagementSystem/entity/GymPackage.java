package com.gym.GymManagementSystem.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

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

    @Column(name = "package_name", nullable = false)
    private String packageName;

    private String duration;

    private BigDecimal price;

    @Column(columnDefinition = "TEXT")
    private String description;
}