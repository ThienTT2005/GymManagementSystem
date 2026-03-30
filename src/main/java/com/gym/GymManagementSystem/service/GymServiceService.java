package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.GymService;

import java.util.List;

public interface GymServiceService {
    List<GymService> findAll();
    GymService findById(Long id);
    GymService save(GymService gymService);
    void deleteById(Long id);
}