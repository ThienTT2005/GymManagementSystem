package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.GymPackage;

import java.util.List;

public interface GymPackageService {
    List<GymPackage> findAll();
    GymPackage findById(Long id);
    GymPackage save(GymPackage gymPackage);
    void deleteById(Long id);
}