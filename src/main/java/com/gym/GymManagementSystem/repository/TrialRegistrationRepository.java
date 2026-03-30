package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.TrialRegistration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TrialRegistrationRepository extends JpaRepository<TrialRegistration, Long> {

    List<TrialRegistration> findTop5ByStatusOrderByRegisterDateDesc(String status);
}