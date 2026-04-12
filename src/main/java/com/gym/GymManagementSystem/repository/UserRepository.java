package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findByRoleEntity_RoleNameIgnoreCase(String roleName);

    Optional<User> findByUsername(String username);

    @Query("""
            SELECT u FROM User u
            JOIN FETCH u.roleEntity r
            LEFT JOIN FETCH u.member
            LEFT JOIN FETCH u.staff
            WHERE u.username = :username
            """)
    Optional<User> findByUsernameFetched(@Param("username") String username);

    User findByUsernameAndPassword(String username, String password);

    boolean existsByUsername(String username);

    @Query("""
            SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END
            FROM User u
            LEFT JOIN u.member m
            LEFT JOIN u.staff s
            WHERE m.phone = :phone OR s.phone = :phone
            """)
    boolean existsByPhone(@Param("phone") String phone);

    @Query("""
            SELECT DISTINCT u
            FROM User u
            LEFT JOIN u.member m
            LEFT JOIN u.staff s
            WHERE
                (:keyword IS NULL OR :keyword = '' OR
                 LOWER(COALESCE(u.username, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(m.fullname, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(m.email, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(m.phone, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(s.fullName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(s.email, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                 LOWER(COALESCE(s.phone, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
            AND
                (:role IS NULL OR :role = '' OR LOWER(u.roleEntity.roleName) = LOWER(:role))
            AND
                (:status IS NULL OR :status = '' OR
                 (:status = 'Hoạt động' AND u.statusCode = 1) OR
                 (:status = 'Khóa' AND u.statusCode = 0))
            """)
    Page<User> searchUsers(@Param("keyword") String keyword,
                           @Param("role") String role,
                           @Param("status") String status,
                           Pageable pageable);

    @Query("""
            SELECT u FROM User u
            LEFT JOIN FETCH u.member
            LEFT JOIN FETCH u.staff
            JOIN FETCH u.roleEntity
            WHERE u.userId = :id
            """)
    Optional<User> findByIdWithProfiles(@Param("id") Long id);
}
