package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Classes;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GymClassRepository extends JpaRepository<Classes, Integer> {
    List<Classes> findByStatus(String status);
}