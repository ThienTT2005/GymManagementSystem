package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.TrainerRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TrainerService {

    private final TrainerRepository trainerRepository;
    private final StaffRepository staffRepository;

    public TrainerService(TrainerRepository trainerRepository,
                          StaffRepository staffRepository) {
        this.trainerRepository = trainerRepository;
        this.staffRepository = staffRepository;
    }

    public Page<Trainer> searchTrainers(String keyword, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "trainerId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasStatus) {
            return trainerRepository.searchByKeywordAndStatus(keyword.trim(), status, pageable);
        }

        if (hasKeyword) {
            return trainerRepository.searchByKeyword(keyword.trim(), pageable);
        }

        if (hasStatus) {
            return trainerRepository.findByStatus(status, pageable);
        }

        return trainerRepository.findAll(pageable);
    }

    public Trainer getTrainerById(Integer id) {
        return trainerRepository.findById(id).orElse(null);
    }

    public Trainer getTrainerByUserId(Integer userId) {
        return trainerRepository.findByStaff_User_UserId(userId).orElse(null);
    }

    public List<Staff> getAvailableStaffForTrainer() {
        return staffRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName")).stream()
                .filter(s -> !trainerRepository.existsByStaff_StaffId(s.getStaffId()))
                .toList();
    }

    public List<Staff> getAllStaff() {
        return staffRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName"));
    }

    public boolean existsByStaffId(Integer staffId, Integer excludeTrainerId) {
        if (staffId == null) {
            return false;
        }
        if (excludeTrainerId == null) {
            return trainerRepository.existsByStaff_StaffId(staffId);
        }
        return trainerRepository.existsByStaff_StaffIdAndTrainerIdNot(staffId, excludeTrainerId);
    }

    public Trainer createTrainer(Trainer trainer, Integer staffId, MultipartFile photoFile) {
        bindStaff(trainer, staffId);
        trainer.setPhoto(storeImage(photoFile, trainer.getPhoto()));
        if (trainer.getStatus() == null) {
            trainer.setStatus(1);
        }
        return trainerRepository.save(trainer);
    }

    public Trainer updateTrainer(Integer id, Trainer formTrainer, Integer staffId, MultipartFile photoFile) {
        Optional<Trainer> optional = trainerRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Trainer existing = optional.get();
        existing.setSpecialty(formTrainer.getSpecialty());
        existing.setExperience(formTrainer.getExperience());
        existing.setCertifications(formTrainer.getCertifications());
        existing.setStatus(formTrainer.getStatus());
        existing.setPhoto(storeImage(photoFile, existing.getPhoto()));

        bindStaff(existing, staffId);
        return trainerRepository.save(existing);
    }

    public boolean softDeleteTrainer(Integer id) {
        Optional<Trainer> optional = trainerRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        Trainer trainer = optional.get();
        trainer.setStatus(0);
        trainerRepository.save(trainer);
        return true;
    }

    private void bindStaff(Trainer trainer, Integer staffId) {
        Staff staff = staffId != null ? staffRepository.findById(staffId).orElse(null) : null;
        trainer.setStaff(staff);
    }

    private String storeImage(MultipartFile file, String currentValue) {
        if (file == null || file.isEmpty()) {
            return currentValue;
        }

        String original = file.getOriginalFilename();
        String ext = "";
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }

        return "trainer-" + UUID.randomUUID() + ext;
    }
}