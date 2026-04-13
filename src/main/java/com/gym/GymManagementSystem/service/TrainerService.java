package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.TrainerRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TrainerService {

    private final TrainerRepository trainerRepository;
    private final StaffRepository staffRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public TrainerService(TrainerRepository trainerRepository,
                          StaffRepository staffRepository) {
        this.trainerRepository = trainerRepository;
        this.staffRepository = staffRepository;
    }

    public Page<Trainer> searchTrainers(String keyword, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size > 0 ? size : 8);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        Page<Trainer> rawPage;

        if (hasKeyword && hasStatus) {
            rawPage = trainerRepository.searchByKeywordAndStatus(keyword.trim(), status, pageable);
        } else if (hasKeyword) {
            rawPage = trainerRepository.searchByKeyword(keyword.trim(), pageable);
        } else if (hasStatus) {
            rawPage = trainerRepository.findByStatus(status, pageable);
        } else {
            rawPage = trainerRepository.findAll(pageable);
        }

        List<Trainer> sortedContent = rawPage.getContent()
                .stream()
                .sorted(trainerNameComparator())
                .toList();

        return new PageImpl<>(sortedContent, pageable, rawPage.getTotalElements());
    }

    public Trainer getTrainerById(Integer id) {
        return trainerRepository.findById(id).orElse(null);
    }

    public Trainer getTrainerByUserId(Integer userId) {
        return trainerRepository.findByStaff_User_UserId(userId).orElse(null);
    }

    public List<Staff> getAvailableStaffForTrainer() {
        return staffRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName")).stream()
                .filter(s -> s.getStatus() != null && s.getStatus() == 1)
                .filter(this::isTrainerRoleStaff)
                .filter(s -> !trainerRepository.existsByStaff_StaffId(s.getStaffId()))
                .toList();
    }

    public List<Staff> getAvailableStaffForTrainer(Integer excludeTrainerId) {
        return staffRepository.findAll(Sort.by(Sort.Direction.ASC, "fullName")).stream()
                .filter(s -> s.getStatus() != null && s.getStatus() == 1)
                .filter(this::isTrainerRoleStaff)
                .filter(s -> !trainerRepository.existsByStaff_StaffIdAndTrainerIdNot(s.getStaffId(), excludeTrainerId))
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
        if (trainer == null) {
            throw new IllegalArgumentException("Thông tin huấn luyện viên không hợp lệ");
        }

        validateTrainer(trainer);
        bindStaff(trainer, staffId, null);
        trainer.setPhoto(storeImage(photoFile, trainer.getPhoto(), "trainer-"));

        if (trainer.getStatus() == null) {
            trainer.setStatus(1);
        }

        return trainerRepository.save(trainer);
    }

    public Trainer updateOwnPhoto(Integer userId, MultipartFile photoFile) {
        Trainer trainer = getTrainerByUserId(userId);
        if (trainer == null) {
            return null;
        }

        String photo = storeImage(photoFile, trainer.getPhoto(), "trainer-");
        trainer.setPhoto(photo);
        return trainerRepository.save(trainer);
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

    public Trainer updateTrainer(Integer id, Trainer formTrainer, Integer staffId, MultipartFile photoFile) {
        Optional<Trainer> optional = trainerRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Trainer existing = optional.get();

        validateTrainer(formTrainer);

        existing.setSpecialty(formTrainer.getSpecialty());
        existing.setExperience(formTrainer.getExperience());
        existing.setCertifications(formTrainer.getCertifications());
        existing.setStatus(formTrainer.getStatus());
        existing.setPhoto(storeImage(photoFile, existing.getPhoto(), "trainer-"));

        bindStaff(existing, staffId, id);

        return trainerRepository.save(existing);
    }

    private Comparator<Trainer> trainerNameComparator() {
        return Comparator
                .comparing((Trainer trainer) -> extractLastName(trainer.getStaffName()))
                .thenComparing(trainer -> normalizeNameForSort(trainer.getStaffName()))
                .thenComparing(Trainer::getTrainerId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private String extractLastName(String fullName) {
        String normalized = normalizeNameForSort(fullName);
        if (normalized.isEmpty()) {
            return "";
        }

        String[] parts = normalized.split(" ");
        return parts[parts.length - 1];
    }

    private String normalizeNameForSort(String fullName) {
        if (fullName == null) {
            return "";
        }

        return removeAccent(fullName.trim().replaceAll("\\s+", " ")).toLowerCase();
    }

    private String removeAccent(String value) {
        if (value == null) {
            return "";
        }

        return Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
    }

    private void bindStaff(Trainer trainer, Integer staffId, Integer excludeTrainerId) {
        if (staffId == null) {
            throw new IllegalArgumentException("Vui lòng chọn nhân viên");
        }

        if (existsByStaffId(staffId, excludeTrainerId)) {
            throw new IllegalArgumentException("Nhân viên này đã là huấn luyện viên");
        }

        Staff staff = staffRepository.findById(staffId).orElse(null);
        if (staff == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên được chọn");
        }

        if (staff.getStatus() == null || staff.getStatus() != 1) {
            throw new IllegalArgumentException("Chỉ được chọn nhân viên đang hoạt động");
        }

        if (!isTrainerRoleStaff(staff)) {
            throw new IllegalArgumentException("Chỉ được chọn staff có user role TRAINER");
        }

        trainer.setStaff(staff);
    }

    private boolean isTrainerRoleStaff(Staff staff) {
        return staff != null
                && staff.getUser() != null
                && staff.getUser().getRoleName() != null
                && "TRAINER".equalsIgnoreCase(staff.getUser().getRoleName().trim());
    }

    private void validateTrainer(Trainer trainer) {
        if (trainer.getStatus() == null) {
            trainer.setStatus(1);
        }

        if (trainer.getStatus() != 0 && trainer.getStatus() != 1) {
            throw new IllegalArgumentException("Trạng thái huấn luyện viên không hợp lệ");
        }
    }

    private String storeImage(MultipartFile file, String currentValue, String prefix) {
        if (file == null || file.isEmpty()) {
            return currentValue;
        }

        try {
            String original = file.getOriginalFilename();
            String ext = "";
            if (original != null && original.contains(".")) {
                ext = original.substring(original.lastIndexOf('.'));
            }

            String fileName = prefix + UUID.randomUUID() + ext;

            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);
            Files.copy(file.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Không thể lưu ảnh trainer", e);
        }
    }
}