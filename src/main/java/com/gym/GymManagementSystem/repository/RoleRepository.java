package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByRoleNameIgnoreCase(String roleName);
}
