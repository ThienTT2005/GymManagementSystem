package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.GymClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GymClassRepository extends JpaRepository<GymClass, Integer> {
}