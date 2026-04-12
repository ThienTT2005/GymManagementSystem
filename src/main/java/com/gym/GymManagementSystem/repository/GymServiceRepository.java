package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.GymService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GymServiceRepository extends JpaRepository<GymService, Long> {
    List<GymService> findByStatus(Byte status);
}