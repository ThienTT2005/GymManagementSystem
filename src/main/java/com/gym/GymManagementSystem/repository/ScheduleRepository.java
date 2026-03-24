package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {

    List<Schedule> findByStatus(String status);

    List<Schedule> findByClubClubIdAndStatus(Integer clubId, String status);
}
