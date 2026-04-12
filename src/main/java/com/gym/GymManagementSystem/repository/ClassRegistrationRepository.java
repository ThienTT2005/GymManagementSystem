package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.Membership;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ClassRegistrationRepository extends JpaRepository<ClassRegistration, Integer> {
    List<ClassRegistration> findByMemberMemberIdOrderByCreatedAtDesc(Integer memberId);

    boolean existsByMemberMemberIdAndClassesClassIdAndStatusNot(
            Integer memberId, Integer classId, String status);
    // lấy danh sách đăng ký active/pending
    @Query("SELECT cr FROM ClassRegistration cr " +
            "WHERE cr.member.memberId = :memberId " +
            "AND cr.status IN ('active', 'pending') " +
            "ORDER BY cr.createdAt DESC")
    List<ClassRegistration> findActiveByMemberId(@Param("memberId") Integer memberId);

    Optional<ClassRegistration> findByClassRegistrationId(Integer classRegistrationId);

    // Tìm đăng ký cụ thể để huỷ
    Optional<ClassRegistration> findByClassRegistrationIdAndMemberMemberId(
            Integer classRegistrationId, Integer memberId);
}