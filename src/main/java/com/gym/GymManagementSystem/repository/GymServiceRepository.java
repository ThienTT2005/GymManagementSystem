package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.GymService;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GymServiceRepository extends JpaRepository<GymService, Long> {
}