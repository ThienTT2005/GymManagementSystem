package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.GymPackage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GymPackageRepository extends JpaRepository<GymPackage, Long> {
}