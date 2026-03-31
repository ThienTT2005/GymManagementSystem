package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findByRole(String role);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);

    @Query("""
        SELECT u
        FROM User u
        WHERE
            (:keyword IS NULL OR :keyword = '' OR
             LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(u.phone) LIKE LOWER(CONCAT('%', :keyword, '%')))
        AND
            (:role IS NULL OR :role = '' OR u.role = :role)
        AND
            (:status IS NULL OR :status = '' OR u.status = :status)
        ORDER BY u.userId DESC
    """)
    List<User> searchUsers(@Param("keyword") String keyword,
                           @Param("role") String role,
                           @Param("status") String status);

    @Query("""
    SELECT u
    FROM User u
    WHERE
        (:keyword IS NULL OR :keyword = '' OR
         LOWER(COALESCE(u.username, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
         LOWER(COALESCE(u.fullName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
         LOWER(COALESCE(u.email, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
         LOWER(COALESCE(u.phone, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
    AND
        (:role IS NULL OR :role = '' OR u.role = :role)
    AND
        (:status IS NULL OR :status = '' OR u.status = :status)
""")
    Page<User> searchUsers(@Param("keyword") String keyword,
                           @Param("role") String role,
                           @Param("status") String status,
                           Pageable pageable);
}