package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StaffService {

    private final StaffRepository staffRepository;
    private final UserRepository userRepository;

    public StaffService(StaffRepository staffRepository,
                        UserRepository userRepository) {
        this.staffRepository = staffRepository;
        this.userRepository = userRepository;
    }

    public Page<Staff> searchStaffs(String keyword, String position, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "staffId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasPosition = position != null && !position.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasPosition && hasStatus) {
            return staffRepository.searchByKeywordAndPositionAndStatus(keyword.trim(), position.trim(), status, pageable);
        }

        if (hasKeyword && hasPosition) {
            return staffRepository.searchByKeywordAndPosition(keyword.trim(), position.trim(), pageable);
        }

        if (hasKeyword && hasStatus) {
            return staffRepository.searchByKeywordAndStatus(keyword.trim(), status, pageable);
        }

        if (hasKeyword) {
            return staffRepository.searchByKeyword(keyword.trim(), pageable);
        }

        return staffRepository.findAll(pageable);
    }

    public Staff getStaffById(Integer id) {
        return staffRepository.findById(id).orElse(null);
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

    public Staff createStaff(Staff staff, Integer userId) {
        bindUser(staff, userId);
        if (staff.getStatus() == null) {
            staff.setStatus(1);
        }
        return staffRepository.save(staff);
    }

    public Staff updateStaff(Integer id, Staff formStaff, Integer userId) {
        Optional<Staff> optional = staffRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Staff existing = optional.get();
        existing.setFullName(formStaff.getFullName());
        existing.setPhone(formStaff.getPhone());
        existing.setEmail(formStaff.getEmail());
        existing.setAddress(formStaff.getAddress());
        existing.setGender(formStaff.getGender());
        existing.setDob(formStaff.getDob());
        existing.setPosition(formStaff.getPosition());
        existing.setSalary(formStaff.getSalary());
        existing.setHireDate(formStaff.getHireDate());
        existing.setNote(formStaff.getNote());
        existing.setStatus(formStaff.getStatus());

        bindUser(existing, userId);
        return staffRepository.save(existing);
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
                .filter(u -> !"MEMBER".equalsIgnoreCase(u.getRoleName()))
                .filter(u -> !staffRepository.existsByUser_UserId(u.getUserId()))
                .toList();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"));
    }

    private void bindUser(Staff staff, Integer userId) {
        User user = userId != null ? userRepository.findById(userId).orElse(null) : null;
        staff.setUser(user);
    }
}