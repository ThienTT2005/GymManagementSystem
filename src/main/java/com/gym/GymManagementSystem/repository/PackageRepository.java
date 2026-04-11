package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.PackageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PackageRepository extends JpaRepository<PackageEntity, Integer> {
}