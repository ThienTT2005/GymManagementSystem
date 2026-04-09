package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);

    boolean existsByUsernameAndUserIdNot(String username, Integer userId);

    Page<User> findByUsernameContainingIgnoreCase(String username, Pageable pageable);

    Page<User> findByRole_RoleName(String roleName, Pageable pageable);

    Page<User> findByStatus(Integer status, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndStatus(String username, Integer status, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndRole_RoleName(String username, String roleName, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndRole_RoleNameAndStatus(
            String username, String roleName, Integer status, Pageable pageable
    );

    List<User> findAll(Sort sort);
}