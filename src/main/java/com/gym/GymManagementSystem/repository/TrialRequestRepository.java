package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.TrialRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrialRequestRepository extends JpaRepository<TrialRequest, Long> {
}
