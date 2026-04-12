package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.util.PasswordUtil;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public AuthService(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public User login(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            return null;
        }

        User user = userRepository.findByUsername(username.trim()).orElse(null);
        if (user == null) {
            return null;
        }

        if (user.getStatus() == null || user.getStatus() != 1) {
            return null;
        }

        if (!PasswordUtil.verify(password, user.getPassword())) {
            return null;
        }

        return user;
    }

    public boolean existsByUsername(String username) {
        if (username == null || username.isBlank()) {
            return false;
        }
        return userRepository.existsByUsername(username.trim());
    }

    public void register(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("Thông tin đăng ký không hợp lệ");
        }

        String normalizedUsername = username.trim();

        if (userRepository.existsByUsername(normalizedUsername)) {
            throw new IllegalArgumentException("Tài khoản đã tồn tại");
        }

        Role memberRole = roleRepository.findById(4)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy role MEMBER"));

        User user = new User();
        user.setUsername(normalizedUsername);
        user.setPassword(PasswordUtil.hash(password));
        user.setStatus(1);
        user.setRole(memberRole);

        userRepository.save(user);
    }
}