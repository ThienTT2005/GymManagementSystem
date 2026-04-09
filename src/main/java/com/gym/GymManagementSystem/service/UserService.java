package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;
import java.util.UUID;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserService(UserRepository userRepository,
                       RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public Page<User> searchUsers(String keyword, String roleName, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "userId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasRole = roleName != null && !roleName.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasRole && hasStatus) {
            return userRepository.findByUsernameContainingIgnoreCaseAndRole_RoleNameAndStatus(
                    keyword.trim(), roleName.trim(), status, pageable
            );
        }

        if (hasKeyword && hasRole) {
            return userRepository.findByUsernameContainingIgnoreCaseAndRole_RoleName(
                    keyword.trim(), roleName.trim(), pageable
            );
        }

        if (hasKeyword && hasStatus) {
            return userRepository.findByUsernameContainingIgnoreCaseAndStatus(keyword.trim(), status, pageable);
        }

        if (hasKeyword) {
            return userRepository.findByUsernameContainingIgnoreCase(keyword.trim(), pageable);
        }

        if (hasRole) {
            return userRepository.findByRole_RoleName(roleName.trim(), pageable);
        }

        if (hasStatus) {
            return userRepository.findByStatus(status, pageable);
        }

        return userRepository.findAll(pageable);
    }

    public boolean existsByUsername(String username, Integer excludeUserId) {
        if (excludeUserId == null) {
            return userRepository.existsByUsername(username);
        }
        return userRepository.existsByUsernameAndUserIdNot(username, excludeUserId);
    }

    public User getUserById(Integer id) {
        return userRepository.findById(id).orElse(null);
    }

    public User createUser(User user, MultipartFile avatarFile) {
        user.setAvatar(storeImage(avatarFile, user.getAvatar()));
        user.setRole(resolveRole(user.getRoleName()));
        if (user.getStatus() == null) {
            user.setStatus(1);
        }
        return userRepository.save(user);
    }

    public User updateUser(Integer id, User formUser, MultipartFile avatarFile) {
        Optional<User> optional = userRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        User existing = optional.get();
        existing.setUsername(formUser.getUsername());
        existing.setStatus(formUser.getStatus());
        existing.setRole(resolveRole(formUser.getRoleName()));
        existing.setAvatar(storeImage(avatarFile, existing.getAvatar()));

        if (formUser.getPassword() != null && !formUser.getPassword().isBlank()) {
            existing.setPassword(formUser.getPassword());
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

    public User updateOwnProfile(Integer userId, String username, MultipartFile avatarFile) {
        Optional<User> optional = userRepository.findById(userId);
        if (optional.isEmpty()) {
            return null;
        }

        User user = optional.get();
        user.setUsername(username);
        user.setAvatar(storeImage(avatarFile, user.getAvatar()));

        return userRepository.save(user);
    }

    public boolean changePassword(Integer userId, String currentPassword, String newPassword) {
        Optional<User> optional = userRepository.findById(userId);
        if (optional.isEmpty()) {
            return false;
        }

        User user = optional.get();
        if (user.getPassword() == null || !user.getPassword().equals(currentPassword)) {
            return false;
        }

        user.setPassword(newPassword);
        userRepository.save(user);
        return true;
    }

    private Role resolveRole(String roleName) {
        if (roleName == null || roleName.isBlank()) {
            return null;
        }
        return roleRepository.findByRoleName(roleName).orElse(null);
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

        return "avatar-" + UUID.randomUUID() + ext;
    }
}