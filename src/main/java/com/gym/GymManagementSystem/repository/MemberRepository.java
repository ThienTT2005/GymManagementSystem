package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {

    boolean existsByPhone(String phone);

    Optional<Member> findByUser_UserId(Long userId);

    @Query("""
            SELECT m FROM Member m
            JOIN FETCH m.user u
            JOIN FETCH u.roleEntity r
            LEFT JOIN FETCH u.staff
            WHERE LOWER(m.email) = LOWER(:email)
            """)
    Optional<Member> findByEmailFetched(@Param("email") String email);
}
