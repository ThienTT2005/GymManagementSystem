package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Schedule;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {

    Page<Schedule> findByGymClass_ClassNameContainingIgnoreCase(String className, Pageable pageable);

    Page<Schedule> findByDayOfWeek(String dayOfWeek, Pageable pageable);

    Page<Schedule> findByGymClass_ClassNameContainingIgnoreCaseAndDayOfWeek(
            String className, String dayOfWeek, Pageable pageable
    );

    List<Schedule> findAll(Sort sort);

    List<Schedule> findByGymClass_Trainer_TrainerIdAndStatus(Integer trainerId, Integer status);

    List<Schedule> findByGymClass_ClassId(Integer classId);

    List<Schedule> findByGymClass_ClassIdAndStatus(Integer classId, Integer status);
}
