package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Member;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<Member, Integer> {

    Page<Member> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String fullname, String phone, String email, Pageable pageable
    );

    Page<Member> findByStatus(Integer status, Pageable pageable);

    Page<Member> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
            String fullname, String phone, String email, Integer status, Pageable pageable
    );

    boolean existsByUser_UserId(Integer userId);

    boolean existsByUser_UserIdAndMemberIdNot(Integer userId, Integer memberId);

    java.util.List<Member> findAll(Sort sort);
}