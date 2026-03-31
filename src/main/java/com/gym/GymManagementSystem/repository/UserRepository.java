package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByEmail(String email);

    boolean existsByEmailAndUserIdNot(String email, Integer userId);

    User findByUsernameAndPassword(String username, String password);

    boolean existsByUsername(String username);
}
