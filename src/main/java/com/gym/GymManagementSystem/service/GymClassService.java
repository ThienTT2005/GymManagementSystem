package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.ScheduleRepository;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import com.gym.GymManagementSystem.repository.TrainerRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
public class GymClassService {

    private final GymClassRepository gymClassRepository;
    private final ServiceRepository serviceRepository;
    private final TrainerRepository trainerRepository;
    private final ScheduleRepository scheduleRepository;
    private final ClassRegistrationRepository classRegistrationRepository;
    private final NotificationService notificationService;

    public GymClassService(GymClassRepository gymClassRepository,
                           ServiceRepository serviceRepository,
                           TrainerRepository trainerRepository,
                           ScheduleRepository scheduleRepository,
                           ClassRegistrationRepository classRegistrationRepository,
                           NotificationService notificationService) {
        this.gymClassRepository = gymClassRepository;
        this.serviceRepository = serviceRepository;
        this.trainerRepository = trainerRepository;
        this.scheduleRepository = scheduleRepository;
        this.classRegistrationRepository = classRegistrationRepository;
        this.notificationService = notificationService;
    }

    public Page<GymClass> searchClasses(String keyword, Integer serviceId, Integer trainerId, Integer status, int page, int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;
        String normalizedKeyword = keyword != null ? keyword.trim() : "";

        PageRequest pageable = PageRequest.of(safePage, safeSize);
        Page<GymClass> rawPage;

        boolean hasKeyword = !normalizedKeyword.isEmpty();
        boolean hasService = serviceId != null;
        boolean hasTrainer = trainerId != null;
        boolean hasStatus = status != null;

        if (hasKeyword && hasStatus) {
            rawPage = gymClassRepository.findByClassNameContainingIgnoreCaseAndStatus(normalizedKeyword, status, pageable);
        } else if (hasKeyword) {
            rawPage = gymClassRepository.findByClassNameContainingIgnoreCase(normalizedKeyword, pageable);
        } else if (hasService) {
            rawPage = gymClassRepository.findByService_ServiceId(serviceId, pageable);
        } else if (hasTrainer) {
            rawPage = gymClassRepository.findByTrainer_TrainerId(trainerId, pageable);
        } else if (hasStatus) {
            rawPage = gymClassRepository.findByStatus(status, pageable);
        } else {
            rawPage = gymClassRepository.findAll(pageable);
        }

        List<GymClass> filteredAndSorted = rawPage.getContent().stream()
                .filter(item -> !hasService || (item.getService() != null && serviceId.equals(item.getService().getServiceId())))
                .filter(item -> !hasTrainer || (item.getTrainer() != null && trainerId.equals(item.getTrainer().getTrainerId())))
                .sorted(classNameComparator())
                .toList();

        return new PageImpl<>(filteredAndSorted, pageable, rawPage.getTotalElements());
    }

    public GymClass getClassById(Integer id) {
        return gymClassRepository.findById(id).orElse(null);
    }

    public List<ServiceGym> getAllServices() {
        return serviceRepository.findAll(Sort.by(Sort.Direction.ASC, "serviceName"));
    }

    public List<Trainer> getAllTrainers() {
        return trainerRepository.findAll(Sort.by(Sort.Direction.ASC, "trainerId"));
    }

    public List<GymClass> getAvailableClassesForRegistration() {
        return gymClassRepository.findAll(Sort.by(Sort.Direction.ASC, "className"))
                .stream()
                .filter(this::isAvailableForRegistration)
                .toList();
    }

    public boolean isAvailableForRegistration(GymClass gymClass) {
        if (gymClass == null) {
            return false;
        }

        if (gymClass.getStatus() == null || gymClass.getStatus() != 1) {
            return false;
        }

        Integer maxMember = gymClass.getMaxMember();
        if (maxMember == null || maxMember <= 0) {
            return false;
        }

        int currentMember = gymClass.getCurrentMember() != null ? gymClass.getCurrentMember() : 0;
        return currentMember < maxMember;
    }

    public boolean isFull(GymClass gymClass) {
        if (gymClass == null) {
            return true;
        }

        Integer maxMember = gymClass.getMaxMember();
        int currentMember = gymClass.getCurrentMember() != null ? gymClass.getCurrentMember() : 0;

        if (maxMember == null || maxMember <= 0) {
            return true;
        }

        return currentMember >= maxMember;
    }

    public GymClass createClass(GymClass gymClass, Integer serviceId, Integer trainerId) {
        bindRelations(gymClass, serviceId, trainerId);

        if (gymClass.getStatus() == null) {
            gymClass.setStatus(1);
        }
        gymClass.setCurrentMember(0);

        validateTrainerAvailabilityForClass(gymClass, null);
        GymClass saved = gymClassRepository.save(gymClass);

        if (saved.getTrainer() != null
                && saved.getTrainer().getStaff() != null
                && saved.getTrainer().getStaff().getUser() != null) {

            notificationService.createNotification(
                    saved.getTrainer().getStaff().getUser().getUserId(),
                    "Bạn được gán lớp mới",
                    "Bạn vừa được phân công lớp " + saved.getClassName(),
                    "/trainer/classes"
            );
        }

        return saved;
    }

    public GymClass updateClass(Integer id, GymClass formClass, Integer serviceId, Integer trainerId) {
        Optional<GymClass> optional = gymClassRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        GymClass existing = optional.get();

        Trainer oldTrainer = existing.getTrainer();

        existing.setClassName(formClass.getClassName());
        existing.setDescription(formClass.getDescription());
        existing.setMaxMember(formClass.getMaxMember());
        existing.setCurrentMember(existing.getCurrentMember() == null ? 0 : existing.getCurrentMember());
        existing.setStatus(formClass.getStatus());

        bindRelations(existing, serviceId, trainerId);
        validateTrainerAvailabilityForClass(existing, id);

        GymClass saved = gymClassRepository.save(existing);

        Trainer newTrainer = saved.getTrainer();

        if (newTrainer != null
                && (oldTrainer == null || !newTrainer.getTrainerId().equals(oldTrainer.getTrainerId()))
                && newTrainer.getStaff() != null
                && newTrainer.getStaff().getUser() != null) {

            notificationService.createNotification(
                    newTrainer.getStaff().getUser().getUserId(),
                    "Bạn được gán lớp mới",
                    "Bạn vừa được phân công lớp " + saved.getClassName(),
                    "/trainer/classes"
            );
        }

        return saved;
    }

    public boolean deleteClass(Integer id) {
        Optional<GymClass> optional = gymClassRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        gymClassRepository.deleteById(id);
        return true;
    }

    public void updateStatus(Integer id, Integer status) {
        if (id == null) {
            throw new IllegalArgumentException("Không tìm thấy lớp học");
        }

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        GymClass gymClass = gymClassRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lớp học"));

        gymClass.setStatus(status);
        gymClassRepository.save(gymClass);
    }

    public List<Schedule> getSchedulesByClassId(Integer classId) {
        if (classId == null) {
            return List.of();
        }

        return scheduleRepository.findAll(Sort.by(Sort.Direction.ASC, "dayOfWeek"))
                .stream()
                .filter(s -> s.getGymClass() != null && classId.equals(s.getGymClass().getClassId()))
                .filter(s -> s.getStatus() != null && s.getStatus() == 1)
                .toList();
    }

    public int countActiveMembersByClassId(Integer classId) {
        if (classId == null) {
            return 0;
        }

        return (int) classRegistrationRepository.findAll().stream()
                .filter(r -> r.getGymClass() != null && classId.equals(r.getGymClass().getClassId()))
                .filter(r -> r.getStatus() != null && "ACTIVE".equalsIgnoreCase(r.getStatus()))
                .count();
    }

    private void validateTrainerAvailabilityForClass(GymClass gymClass, Integer excludeClassId) {
        if (gymClass == null || gymClass.getTrainer() == null || gymClass.getTrainer().getTrainerId() == null || gymClass.getClassId() == null && excludeClassId == null) {
            return;
        }

        Integer classId = gymClass.getClassId() != null ? gymClass.getClassId() : excludeClassId;
        if (classId == null) {
            return;
        }

        List<Schedule> classSchedules = scheduleRepository.findByGymClass_ClassIdAndStatus(classId, 1);
        if (classSchedules.isEmpty()) {
            return;
        }

        Integer trainerId = gymClass.getTrainer().getTrainerId();
        List<Schedule> trainerSchedules = scheduleRepository.findByGymClass_Trainer_TrainerIdAndStatus(trainerId, 1);

        for (Schedule classSchedule : classSchedules) {
            if (classSchedule.getDayOfWeek() == null || classSchedule.getStartTime() == null || classSchedule.getEndTime() == null) {
                continue;
            }
            for (Schedule existing : trainerSchedules) {
                if (existing.getGymClass() == null || existing.getGymClass().getClassId() == null) {
                    continue;
                }
                if (existing.getGymClass().getClassId().equals(classId)) {
                    continue;
                }
                if (existing.getDayOfWeek() == null || existing.getStartTime() == null || existing.getEndTime() == null) {
                    continue;
                }
                if (!existing.getDayOfWeek().trim().equalsIgnoreCase(classSchedule.getDayOfWeek().trim())) {
                    continue;
                }

                boolean overlap = classSchedule.getStartTime().isBefore(existing.getEndTime())
                        && classSchedule.getEndTime().isAfter(existing.getStartTime());
                if (overlap) {
                    String trainerName = gymClass.getTrainer().getStaff() != null
                            ? gymClass.getTrainer().getStaff().getFullName()
                            : "Huấn luyện viên";
                    throw new IllegalArgumentException(
                            trainerName + " đã có lớp trùng lịch vào " + existing.getDayOfWeek()
                                    + " (" + existing.getStartTime() + " - " + existing.getEndTime() + ")"
                    );
                }
            }
        }
    }

    private Comparator<GymClass> classNameComparator() {
        return Comparator
                .comparing((GymClass item) -> normalizeClassName(item.getClassName()))
                .thenComparing(GymClass::getClassId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private String normalizeClassName(String value) {
        if (value == null) {
            return "";
        }

        return Normalizer.normalize(value.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase();
    }

    private void bindRelations(GymClass gymClass, Integer serviceId, Integer trainerId) {
        ServiceGym service = serviceId != null ? serviceRepository.findById(serviceId).orElse(null) : null;
        Trainer trainer = trainerId != null ? trainerRepository.findById(trainerId).orElse(null) : null;

        gymClass.setService(service);
        gymClass.setTrainer(trainer);
    }
}