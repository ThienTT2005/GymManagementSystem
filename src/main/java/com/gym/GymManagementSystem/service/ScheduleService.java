package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.Schedule;

import java.util.List;

public interface ScheduleService {
    List<Schedule> findAll();
    Schedule findById(Long id);
    Schedule save(Schedule schedule);
    void deleteById(Long id);
}