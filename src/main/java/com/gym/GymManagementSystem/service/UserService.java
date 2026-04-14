package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.util.PasswordUtil;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final NotificationService notificationService;

    public UserService(UserRepository userRepository,
                       RoleRepository roleRepository,
                       NotificationService notificationService) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.notificationService = notificationService;
    }

    public Page<User> searchUsers(String keyword, Integer roleId, Integer status, int page, int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        PageRequest pageable = PageRequest.of(safePage, safeSize);

        String normalizedKeyword = keyword != null ? keyword.trim() : "";

        return userRepository.searchUsersSorted(
                normalizedKeyword,
                roleId,
                status,
                pageable
        );
    }

    public boolean existsByUsername(String username, Integer excludeUserId) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        String normalized = username.trim();

        if (excludeUserId == null) {
            return userRepository.existsByUsername(normalized);
        }

        return userRepository.existsByUsernameAndUserIdNot(normalized, excludeUserId);
    }

    public boolean isValidRoleId(Integer roleId) {
        return roleId != null && roleRepository.existsById(roleId);
    }

    public List<Role> getAllRoles() {
        return roleRepository.findAll(Sort.by(Sort.Direction.ASC, "roleId"));
    }

    public User getUserById(Integer id) {
        return userRepository.findById(id).orElse(null);
    }

    public User createUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("Thông tin tài khoản không hợp lệ");
        }

        String username = normalizeUsername(user.getUsername());
        user.setUsername(username);

        if (existsByUsername(username, null)) {
            throw new IllegalArgumentException("Username đã tồn tại");
        }

        Role role = roleRepository.findById(user.getRoleId()).orElse(null);
        if (role == null) {
            throw new IllegalArgumentException("Role không hợp lệ");
        }
        user.setRole(role);

        if (user.getStatus() == null) {
            user.setStatus(1);
        }

        if (user.getStatus() != 0 && user.getStatus() != 1) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        if (user.getPassword() == null || user.getPassword().isBlank()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }

        user.setPassword(PasswordUtil.hash(user.getPassword().trim()));

        User savedUser = userRepository.save(user);

        notificationService.createNotificationForRole(
                "RECEPTIONIST",
                "Tài khoản mới",
                "Tài khoản " + savedUser.getUsername() + " vừa được tạo mới",
                "/receptionist/dashboard"
        );
        notificationService.createNotificationForRole(
                "ADMIN",
                "Tài khoản mới",
                "Tài khoản " + savedUser.getUsername() + " vừa được tạo mới",
                "/admin/users"
        );

        return savedUser;
    }

    public User updateUser(Integer id, User formUser) {
        Optional<User> optional = userRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        User existing = optional.get();

        String username = normalizeUsername(formUser.getUsername());
        if (existsByUsername(username, id)) {
            throw new IllegalArgumentException("Username đã tồn tại");
        }

        existing.setUsername(username);
        existing.setStatus(formUser.getStatus());

        if (existing.getStatus() == null || (existing.getStatus() != 0 && existing.getStatus() != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        Role role = roleRepository.findById(formUser.getRoleId()).orElse(null);
        if (role == null) {
            throw new IllegalArgumentException("Role không hợp lệ");
        }
        existing.setRole(role);

        if (formUser.getPassword() != null && !formUser.getPassword().isBlank()) {
            existing.setPassword(PasswordUtil.hash(formUser.getPassword().trim()));
        }

        return userRepository.save(existing);
    }

    public boolean softDeleteUser(Integer id) {
        Optional<User> optional = userRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        User user = optional.get();
        user.setStatus(0);
        userRepository.save(user);
        return true;
    }

    public User updateOwnProfile(Integer userId, String username) {
        Optional<User> optional = userRepository.findById(userId);
        if (optional.isEmpty()) {
            return null;
        }

        String normalized = normalizeUsername(username);

        if (existsByUsername(normalized, userId)) {
            throw new IllegalArgumentException("Username đã tồn tại");
        }

        User user = optional.get();
        user.setUsername(normalized);

        return userRepository.save(user);
    }

    public void changePassword(Integer userId,
                               String currentPassword,
                               String newPassword,
                               String confirmPassword) {
        Optional<User> optional = userRepository.findById(userId);
        if (optional.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy tài khoản");
        }

        User user = optional.get();

        if (currentPassword == null || currentPassword.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không được để trống");
        }

        if (!PasswordUtil.verify(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không đúng");
        }

        if (newPassword == null || newPassword.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống");
        }

        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu mới phải >= 6 ký tự");
        }

        if (confirmPassword == null || confirmPassword.isBlank()) {
            throw new IllegalArgumentException("Xác nhận mật khẩu không được để trống");
        }

        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Xác nhận mật khẩu không khớp");
        }

        if (PasswordUtil.verify(newPassword, user.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu mới không được trùng mật khẩu cũ");
        }

        user.setPassword(PasswordUtil.hash(newPassword));
        userRepository.save(user);
    }

    public void updateStatus(int userId, int status) {
        if (status != 0 && status != 1) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy tài khoản"));

        user.setStatus(status);
        userRepository.save(user);
    }

    private String normalizeUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username không được để trống");
        }
        return username.trim();
    }
}