package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.ScheduleRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final GymClassRepository gymClassRepository;

    public ScheduleService(ScheduleRepository scheduleRepository,
                           GymClassRepository gymClassRepository) {
        this.scheduleRepository = scheduleRepository;
        this.gymClassRepository = gymClassRepository;
    }

    public Page<Schedule> searchSchedules(String keyword, String dayOfWeek, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.ASC, "dayOfWeek"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasDay = dayOfWeek != null && !dayOfWeek.trim().isEmpty();

        if (hasKeyword && hasDay) {
            return scheduleRepository.findByGymClass_ClassNameContainingIgnoreCaseAndDayOfWeek(keyword.trim(), dayOfWeek.trim(), pageable);
        }

        if (hasKeyword) {
            return scheduleRepository.findByGymClass_ClassNameContainingIgnoreCase(keyword.trim(), pageable);
        }

        if (hasDay) {
            return scheduleRepository.findByDayOfWeek(dayOfWeek.trim(), pageable);
        }

        return scheduleRepository.findAll(pageable);
    }

    public List<GymClass> getAllClasses() {
        return gymClassRepository.findAll(Sort.by(Sort.Direction.ASC, "className"));
    }

    public Schedule getScheduleById(Integer id) {
        return scheduleRepository.findById(id).orElse(null);
    }

    public Schedule createSchedule(Schedule schedule, Integer classId) {
        bindClass(schedule, classId);
        if (schedule.getStatus() == null) {
            schedule.setStatus(1);
        }
        return scheduleRepository.save(schedule);
    }

    public Schedule updateSchedule(Integer id, Schedule formSchedule, Integer classId) {
        Optional<Schedule> optional = scheduleRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Schedule existing = optional.get();
        existing.setDayOfWeek(formSchedule.getDayOfWeek());
        existing.setStartTime(formSchedule.getStartTime());
        existing.setEndTime(formSchedule.getEndTime());
        existing.setStatus(formSchedule.getStatus());

        bindClass(existing, classId);
        return scheduleRepository.save(existing);
    }

    public boolean softDeleteSchedule(Integer id) {
        Optional<Schedule> optional = scheduleRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        Schedule schedule = optional.get();
        schedule.setStatus(0);
        scheduleRepository.save(schedule);
        return true;
    }

    public List<Schedule> findAll() {
        return scheduleRepository.findAll(Sort.by(Sort.Direction.ASC, "dayOfWeek"));
    }

    private void bindClass(Schedule schedule, Integer classId) {
        GymClass gymClass = classId != null ? gymClassRepository.findById(classId).orElse(null) : null;
        schedule.setGymClass(gymClass);
    }
}