package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.ScheduleRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Comparator;
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
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        PageRequest pageable = PageRequest.of(safePage, safeSize);

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasDay = dayOfWeek != null && !dayOfWeek.trim().isEmpty();

        Page<Schedule> rawPage;

        if (hasKeyword && hasDay) {
            rawPage = scheduleRepository.findByGymClass_ClassNameContainingIgnoreCaseAndDayOfWeek(
                    keyword.trim(), dayOfWeek.trim(), pageable
            );
        } else if (hasKeyword) {
            rawPage = scheduleRepository.findByGymClass_ClassNameContainingIgnoreCase(
                    keyword.trim(), pageable
            );
        } else if (hasDay) {
            rawPage = scheduleRepository.findByDayOfWeek(dayOfWeek.trim(), pageable);
        } else {
            rawPage = scheduleRepository.findAll(pageable);
        }

        List<Schedule> sortedContent = rawPage.getContent().stream()
                .sorted(scheduleComparator())
                .toList();

        return new PageImpl<>(sortedContent, pageable, rawPage.getTotalElements());
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

        validateScheduleTime(schedule);
        validateClassScheduleConflict(schedule, null);
        validateTrainerScheduleConflict(schedule, null);

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
        validateScheduleTime(existing);
        validateClassScheduleConflict(existing, id);
        validateTrainerScheduleConflict(existing, id);

        return scheduleRepository.save(existing);
    }

    public void updateStatus(Integer id, Integer status) {
        if (id == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch học");
        }

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lịch học"));

        schedule.setStatus(status);
        scheduleRepository.save(schedule);
    }

    public boolean deleteSchedule(Integer id) {
        if (!scheduleRepository.existsById(id)) return false;
        scheduleRepository.deleteById(id);
        return true;
    }

    public List<Schedule> findAll() {
        return scheduleRepository.findAll(Sort.by(Sort.Direction.ASC, "dayOfWeek"))
                .stream()
                .sorted(scheduleComparator())
                .toList();
    }

    private void validateScheduleTime(Schedule schedule) {
        if (schedule.getGymClass() == null || schedule.getGymClass().getClassId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn lớp học");
        }

        if (schedule.getDayOfWeek() == null || schedule.getDayOfWeek().trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn thứ trong tuần");
        }

        if (schedule.getStartTime() == null || schedule.getEndTime() == null) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ giờ bắt đầu và giờ kết thúc");
        }

        if (!schedule.getEndTime().isAfter(schedule.getStartTime())) {
            throw new IllegalArgumentException("Giờ kết thúc phải lớn hơn giờ bắt đầu");
        }
    }

    private void validateClassScheduleConflict(Schedule schedule, Integer excludeScheduleId) {
        if (schedule == null || schedule.getGymClass() == null || schedule.getGymClass().getClassId() == null) {
            return;
        }

        Integer classId = schedule.getGymClass().getClassId();

        List<Schedule> classSchedules = scheduleRepository.findByGymClass_ClassId(classId);

        for (Schedule existing : classSchedules) {
            if (excludeScheduleId != null && excludeScheduleId.equals(existing.getScheduleId())) {
                continue;
            }

            if (existing.getDayOfWeek() == null || schedule.getDayOfWeek() == null) {
                continue;
            }

            if (!existing.getDayOfWeek().trim().equalsIgnoreCase(schedule.getDayOfWeek().trim())) {
                continue;
            }

            if (existing.getStartTime() == null || existing.getEndTime() == null) {
                continue;
            }

            boolean overlap = schedule.getStartTime().isBefore(existing.getEndTime())
                    && schedule.getEndTime().isAfter(existing.getStartTime());

            if (overlap) {
                String className = schedule.getGymClass().getClassName() != null
                        ? schedule.getGymClass().getClassName()
                        : "Lớp này";

                throw new IllegalArgumentException(
                        className + " đã có lịch trùng vào " + existing.getDayOfWeek()
                                + " (" + existing.getStartTime() + " - " + existing.getEndTime() + ")"
                );
            }
        }
    }

    private void validateTrainerScheduleConflict(Schedule schedule, Integer excludeScheduleId) {
        if (schedule == null || schedule.getGymClass() == null || schedule.getGymClass().getTrainer() == null) {
            return;
        }

        Integer trainerId = schedule.getGymClass().getTrainer().getTrainerId();
        if (trainerId == null) {
            return;
        }

        List<Schedule> trainerSchedules = scheduleRepository.findByGymClass_Trainer_TrainerIdAndStatus(trainerId, 1);

        for (Schedule existing : trainerSchedules) {
            if (excludeScheduleId != null && excludeScheduleId.equals(existing.getScheduleId())) {
                continue;
            }

            if (existing.getDayOfWeek() == null || schedule.getDayOfWeek() == null) {
                continue;
            }

            if (!existing.getDayOfWeek().trim().equalsIgnoreCase(schedule.getDayOfWeek().trim())) {
                continue;
            }

            if (existing.getStartTime() == null || existing.getEndTime() == null) {
                continue;
            }

            boolean overlap = schedule.getStartTime().isBefore(existing.getEndTime())
                    && schedule.getEndTime().isAfter(existing.getStartTime());

            if (overlap) {
                Integer currentClassId = schedule.getGymClass().getClassId();
                Integer existingClassId = existing.getGymClass() != null ? existing.getGymClass().getClassId() : null;

                if (currentClassId != null && currentClassId.equals(existingClassId)) {
                    continue;
                }

                String trainerName = schedule.getGymClass().getTrainer().getStaff() != null
                        ? schedule.getGymClass().getTrainer().getStaff().getFullName()
                        : "Huấn luyện viên";

                String className = existing.getGymClass() != null && existing.getGymClass().getClassName() != null
                        ? existing.getGymClass().getClassName()
                        : "lớp khác";

                throw new IllegalArgumentException(
                        trainerName + " đã có lớp trùng lịch vào " + existing.getDayOfWeek()
                                + " (" + existing.getStartTime() + " - " + existing.getEndTime() + ") ở lớp " + className
                );
            }
        }
    }

    private void bindClass(Schedule schedule, Integer classId) {
        GymClass gymClass = classId != null ? gymClassRepository.findById(classId).orElse(null) : null;
        schedule.setGymClass(gymClass);
    }

    private Comparator<Schedule> scheduleComparator() {
        return Comparator
                .comparingInt((Schedule item) -> dayOfWeekOrder(item.getDayOfWeek()))
                .thenComparing(Schedule::getStartTime, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(Schedule::getEndTime, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(Schedule::getScheduleId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private int dayOfWeekOrder(String dayOfWeek) {
        if (dayOfWeek == null) {
            return 99;
        }

        return switch (dayOfWeek.trim().toUpperCase()) {
            case "MONDAY" -> 1;
            case "TUESDAY" -> 2;
            case "WEDNESDAY" -> 3;
            case "THURSDAY" -> 4;
            case "FRIDAY" -> 5;
            case "SATURDAY" -> 6;
            case "SUNDAY" -> 7;
            default -> 99;
        };
    }
}