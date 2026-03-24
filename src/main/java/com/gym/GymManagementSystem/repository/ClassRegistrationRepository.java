package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.ClassRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ClassRegistrationRepository extends JpaRepository<ClassRegistration, Integer> {

    boolean existsByUserUserIdAndScheduleScheduleIdAndStatus(
            Integer userId, Integer scheduleId, String status);

    long countByScheduleScheduleIdAndStatus(Integer scheduleId, String status);

    List<ClassRegistration> findByUserUserIdOrderByCreatedAtDesc(Integer userId);
}