package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    List<Schedule> findTop5ByScheduleDateOrderByScheduleTimeAsc(LocalDate scheduleDate);
}