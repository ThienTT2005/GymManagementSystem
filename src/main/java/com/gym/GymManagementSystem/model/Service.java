package com.gym.GymManagementSystem.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "services")
@Data
public class Service {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int serviceId;

    private String serviceName;
    private double price;
    private String description;
    private String image;
    private int status;
}