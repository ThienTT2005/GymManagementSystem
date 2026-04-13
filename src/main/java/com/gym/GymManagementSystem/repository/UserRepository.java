package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);

    boolean existsByUsernameAndUserIdNot(String username, Integer userId);

    Page<User> findByUsernameContainingIgnoreCase(String username, Pageable pageable);

    Page<User> findByRole_RoleId(Integer roleId, Pageable pageable);

    Page<User> findByStatus(Integer status, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndStatus(String username, Integer status, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndRole_RoleId(String username, Integer roleId, Pageable pageable);

    Page<User> findByUsernameContainingIgnoreCaseAndRole_RoleIdAndStatus(
            String username, Integer roleId, Integer status, Pageable pageable
    );

    List<User> findAll(Sort sort);

    @Query("""
            SELECT u
            FROM User u
            JOIN u.role r
            WHERE (:keyword IS NULL OR :keyword = '' OR LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')))
              AND (:roleId IS NULL OR r.roleId = :roleId)
              AND (:status IS NULL OR u.status = :status)
            ORDER BY
              CASE
                WHEN UPPER(r.roleName) = 'ADMIN' THEN 1
                WHEN UPPER(r.roleName) = 'RECEPTIONIST' THEN 2
                WHEN UPPER(r.roleName) = 'TRAINER' THEN 3
                WHEN UPPER(r.roleName) = 'MEMBER' THEN 4
                ELSE 99
              END ASC,
              u.createdAt DESC,
              u.userId DESC
            """)
    Page<User> searchUsersSorted(
            @Param("keyword") String keyword,
            @Param("roleId") Integer roleId,
            @Param("status") Integer status,
            Pageable pageable
    );
}