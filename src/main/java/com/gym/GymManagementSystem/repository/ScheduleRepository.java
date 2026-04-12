package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {
    List<Schedule> findByClassesClassIdAndStatus(Integer classId, String status);
    List<Schedule> findByStatus(String status);
}
