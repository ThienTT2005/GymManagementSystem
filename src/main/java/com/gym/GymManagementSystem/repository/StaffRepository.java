package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface StaffRepository extends JpaRepository<Staff, Long> {

    boolean existsByPhone(String phone);

    Optional<Staff> findByUser_UserId(Long userId);

    @Query("""
            SELECT s FROM Staff s
            JOIN FETCH s.user u
            JOIN FETCH u.roleEntity r
            LEFT JOIN FETCH u.member
            WHERE LOWER(s.email) = LOWER(:email)
            """)
    Optional<Staff> findByEmailFetched(@Param("email") String email);
}
