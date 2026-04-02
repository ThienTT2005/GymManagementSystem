package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.User;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public List<User> findByRole(String role) {
        return userRepository.findByRole(role);
    }
    @Override
    public Page<User> searchUsers(String keyword, String role, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("fullName").ascending());
        return userRepository.searchUsers(keyword, role, status, pageable);
    }
    @Override
    public void toggleStatus(Long id) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            if ("Hoạt động".equalsIgnoreCase(user.getStatus())) {
                user.setStatus("Khóa");
            } else {
                user.setStatus("Hoạt động");
            }
            userRepository.save(user);
        }
    }
}