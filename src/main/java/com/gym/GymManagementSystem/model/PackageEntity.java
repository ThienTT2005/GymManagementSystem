package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "packages")
@Data
public class PackageEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int packageId;

    private String packageName;
    private double price;
    private int durationMonths;
    private String description;
    private String image;
    private int status;
}