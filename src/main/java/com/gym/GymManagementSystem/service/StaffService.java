package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
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
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class StaffService {

    private final StaffRepository staffRepository;
    private final UserRepository userRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public StaffService(StaffRepository staffRepository,
                        UserRepository userRepository) {
        this.staffRepository = staffRepository;
        this.userRepository = userRepository;
    }

    public Page<Staff> searchStaffs(String keyword, String position, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size > 0 ? size : 8);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasPosition = position != null && !position.trim().isEmpty();
        boolean hasStatus = status != null;

        Page<Staff> rawPage;

        if (hasKeyword && hasPosition && hasStatus) {
            rawPage = staffRepository.searchByKeywordAndPositionAndStatus(keyword.trim(), position.trim(), status, pageable);
        } else if (hasKeyword && hasPosition) {
            rawPage = staffRepository.searchByKeywordAndPosition(keyword.trim(), position.trim(), pageable);
        } else if (hasKeyword && hasStatus) {
            rawPage = staffRepository.searchByKeywordAndStatus(keyword.trim(), status, pageable);
        } else if (hasKeyword) {
            rawPage = staffRepository.searchByKeyword(keyword.trim(), pageable);
        } else if (hasStatus) {
            rawPage = staffRepository.findByStatus(status, pageable);
        } else {
            rawPage = staffRepository.findAll(pageable);
        }

        List<Staff> sortedContent = rawPage.getContent()
                .stream()
                .sorted(staffRoleAndNameComparator())
                .toList();

        return new PageImpl<>(sortedContent, pageable, rawPage.getTotalElements());
    }

    public Staff getStaffById(Integer id) {
        return staffRepository.findById(id).orElse(null);
    }

    public Staff getStaffByUserId(Integer userId) {
        return staffRepository.findAll(Sort.by(Sort.Direction.ASC, "staffId")).stream()
                .filter(s -> s.getUser() != null && s.getUser().getUserId().equals(userId))
                .findFirst()
                .orElse(null);
    }

    public boolean existsByUserId(Integer userId, Integer excludeStaffId) {
        if (userId == null) {
            return false;
        }
        if (excludeStaffId == null) {
            return staffRepository.existsByUser_UserId(userId);
        }
        return staffRepository.existsByUser_UserIdAndStaffIdNot(userId, excludeStaffId);
    }

    public Staff createStaff(Staff staff, Integer userId, MultipartFile avatarFile) {
        if (staff == null) {
            throw new IllegalArgumentException("Không nhận được dữ liệu nhân viên từ form");
        }

        normalizeStaff(staff);

        if (userId == null) {
            throw new IllegalArgumentException("Vui lòng chọn tài khoản");
        }

        bindUser(staff, userId, null);
        autoSetPositionFromUserRole(staff);

        if (!hasText(staff.getPosition())) {
            throw new IllegalArgumentException("Không thể tự động xác định chức vụ từ role của tài khoản");
        }

        if (staff.getHireDate() == null) {
            staff.setHireDate(LocalDate.now());
        }

        if (avatarFile != null && !avatarFile.isEmpty()) {
            staff.setAvatar(storeImage(avatarFile, null, "staff-avatar-"));
        } else if (!hasText(staff.getAvatar())) {
            staff.setAvatar(defaultAvatar());
        }

        if (staff.getStatus() == null) {
            staff.setStatus(1);
        }

        validateStaff(staff);

        return staffRepository.save(staff);
    }

    public Staff updateStaff(Integer id, Staff formStaff, Integer userId, MultipartFile avatarFile) {
        Optional<Staff> optional = staffRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Staff existing = optional.get();

        if (formStaff == null) {
            throw new IllegalArgumentException("Không nhận được dữ liệu cập nhật nhân viên");
        }

        normalizeStaff(formStaff);

        existing.setFullName(formStaff.getFullName());
        existing.setPhone(formStaff.getPhone());
        existing.setEmail(formStaff.getEmail());
        existing.setAddress(formStaff.getAddress());
        existing.setGender(formStaff.getGender());
        existing.setDob(formStaff.getDob());
        existing.setSalary(formStaff.getSalary());
        existing.setNote(formStaff.getNote());
        existing.setStatus(formStaff.getStatus());

        if (formStaff.getHireDate() != null) {
            existing.setHireDate(formStaff.getHireDate());
        } else if (existing.getHireDate() == null) {
            existing.setHireDate(LocalDate.now());
        }

        if (userId == null) {
            throw new IllegalArgumentException("Vui lòng chọn tài khoản");
        }

        bindUser(existing, userId, id);
        autoSetPositionFromUserRole(existing);

        if (!hasText(existing.getPosition())) {
            throw new IllegalArgumentException("Không thể tự động xác định chức vụ từ role của tài khoản");
        }

        if (avatarFile != null && !avatarFile.isEmpty()) {
            existing.setAvatar(storeImage(avatarFile, existing.getAvatar(), "staff-avatar-"));
        } else if (hasText(formStaff.getAvatar())) {
            existing.setAvatar(formStaff.getAvatar().trim());
        } else if (!hasText(existing.getAvatar())) {
            existing.setAvatar(defaultAvatar());
        }

        validateStaff(existing);

        return staffRepository.save(existing);
    }

    public Staff updateOwnProfile(Integer userId,
                                  String fullName,
                                  String email,
                                  String phone,
                                  String address,
                                  String gender,
                                  LocalDate dob,
                                  MultipartFile avatarFile) {
        Staff staff = getStaffByUserId(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Không tìm thấy hồ sơ nhân viên");
        }

        staff.setFullName(trimToNull(fullName));
        staff.setEmail(trimToNull(email));
        staff.setPhone(trimToNull(phone));
        staff.setAddress(trimToNull(address));
        staff.setGender(trimToNull(gender));
        staff.setDob(dob);

        if (avatarFile != null && !avatarFile.isEmpty()) {
            String avatar = storeImage(avatarFile, staff.getAvatar(), "staff-avatar-");
            staff.setAvatar(avatar);
        } else if (!hasText(staff.getAvatar())) {
            staff.setAvatar(defaultAvatar());
        }

        validateOwnProfile(staff);

        return staffRepository.save(staff);
    }

    public Staff updateOwnAvatar(Integer userId, MultipartFile avatarFile) {
        Staff staff = getStaffByUserId(userId);
        if (staff == null) {
            return null;
        }

        String avatar = storeImage(avatarFile, staff.getAvatar(), "staff-avatar-");
        staff.setAvatar(avatar);
        return staffRepository.save(staff);
    }

    public boolean softDeleteStaff(Integer id) {
        Optional<Staff> optional = staffRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        Staff staff = optional.get();
        staff.setStatus(0);
        staffRepository.save(staff);
        return true;
    }

    public List<User> getAssignableUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username")).stream()
                .filter(this::isStaffRoleUser)
                .filter(User::isActive)
                .filter(u -> !staffRepository.existsByUser_UserId(u.getUserId()))
                .toList();
    }

    public List<User> getAssignableUsers(Integer excludeStaffId) {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username")).stream()
                .filter(this::isStaffRoleUser)
                .filter(User::isActive)
                .filter(u -> {
                    if (excludeStaffId == null) {
                        return !staffRepository.existsByUser_UserId(u.getUserId());
                    }
                    return !staffRepository.existsByUser_UserIdAndStaffIdNot(u.getUserId(), excludeStaffId);
                })
                .toList();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"));
    }

    private void bindUser(Staff staff, Integer userId, Integer excludeStaffId) {
        if (userId == null) {
            staff.setUser(null);
            return;
        }

        if (existsByUserId(userId, excludeStaffId)) {
            throw new IllegalArgumentException("Tài khoản này đã được gán cho nhân viên khác");
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new IllegalArgumentException("Không tìm thấy tài khoản được chọn");
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("Không thể liên kết tài khoản đang bị khóa");
        }

        if (!isStaffRoleUser(user)) {
            throw new IllegalArgumentException("Chỉ được liên kết user có role ADMIN, RECEPTIONIST hoặc TRAINER");
        }

        staff.setUser(user);
    }

    private void autoSetPositionFromUserRole(Staff staff) {
        if (staff == null || staff.getUser() == null || !hasText(staff.getUser().getRoleName())) {
            return;
        }

        String roleName = staff.getUser().getRoleName().trim().toUpperCase();
        switch (roleName) {
            case "ADMIN":
                staff.setPosition("Manager");
                break;
            case "RECEPTIONIST":
                staff.setPosition("Receptionist");
                break;
            case "TRAINER":
                staff.setPosition("Trainer");
                break;
            default:
                staff.setPosition(null);
                break;
        }
    }

    private boolean isStaffRoleUser(User user) {
        if (user == null || user.getRoleName() == null) {
            return false;
        }

        String roleName = user.getRoleName().trim().toUpperCase();
        return "ADMIN".equals(roleName)
                || "RECEPTIONIST".equals(roleName)
                || "TRAINER".equals(roleName);
    }

    private Comparator<Staff> staffRoleAndNameComparator() {
        return Comparator
                .comparingInt(this::getRolePriority)
                .thenComparing(staff -> extractLastName(staff.getFullName()))
                .thenComparing(staff -> normalizeNameForSort(staff.getFullName()))
                .thenComparing(Staff::getStaffId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private int getRolePriority(Staff staff) {
        String roleName = staff != null ? staff.getRoleName() : null;
        if (roleName == null) {
            return 99;
        }

        String normalized = roleName.trim().toUpperCase();
        switch (normalized) {
            case "ADMIN":
                return 1;
            case "RECEPTIONIST":
                return 2;
            case "TRAINER":
                return 3;
            default:
                return 99;
        }
    }

    private String extractLastName(String fullName) {
        String normalized = normalizeNameForSort(fullName);
        if (normalized.isEmpty()) {
            return "";
        }
        String[] parts = normalized.split(" ");
        return removeAccent(parts[parts.length - 1]).toLowerCase();
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

    private void normalizeStaff(Staff staff) {
        if (staff == null) {
            return;
        }

        staff.setFullName(trimToNull(staff.getFullName()));
        staff.setPhone(trimToNull(staff.getPhone()));
        staff.setEmail(trimToNull(staff.getEmail()));
        staff.setAddress(trimToNull(staff.getAddress()));
        staff.setGender(trimToNull(staff.getGender()));
        staff.setPosition(trimToNull(staff.getPosition()));
        staff.setNote(trimToNull(staff.getNote()));
        staff.setAvatar(trimToNull(staff.getAvatar()));
    }

    private void validateStaff(Staff staff) {
        if (!hasText(staff.getFullName())) {
            throw new IllegalArgumentException("Họ tên nhân viên không được để trống");
        }

        if (staff.getStatus() == null) {
            staff.setStatus(1);
        }

        if (staff.getStatus() != 0 && staff.getStatus() != 1) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }
    }

    private void validateOwnProfile(Staff staff) {
        if (!hasText(staff.getFullName())) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }
    }

    private String defaultAvatar() {
        return "default-avatar.png";
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
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

            Files.copy(
                    file.getInputStream(),
                    uploadPath.resolve(fileName),
                    StandardCopyOption.REPLACE_EXISTING
            );

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Không thể lưu ảnh", e);
        }
    }
}