package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.util.PasswordUtil;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
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

    public void register(String username, String password, String fullName) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("Thông tin đăng ký không hợp lệ");
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(PasswordUtil.hash(password));
        user.setRoleId(4);
        user.setStatus(1);

        userRepository.save(user);
    }
}