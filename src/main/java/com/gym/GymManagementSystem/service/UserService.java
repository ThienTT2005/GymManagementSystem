package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.User;
import org.springframework.data.domain.Page;
import java.util.List;

public interface UserService {
    List<User> findAll();
    User findById(Long id);
    User save(User user);
    void deleteById(Long id);
    List<User> findByRole(String role);
    Page<User> searchUsers(String keyword, String role, String status, int page, int size);
    void toggleStatus(Long id);
}