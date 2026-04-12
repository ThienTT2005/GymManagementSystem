package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    Optional<Payment> findTopByMembershipMembershipIdOrderByCreatedAtDesc(Integer membershipId);

    Optional<Payment> findTopByClassRegistrationClassRegistrationIdOrderByCreatedAtDesc(Integer classRegistrationId);

    @Query("""
    SELECT p FROM Payment p
    LEFT JOIN p.membership m
    LEFT JOIN m.member mm
    LEFT JOIN p.classRegistration cr
    LEFT JOIN cr.member cm
    WHERE 
        (mm.memberId = :memberId)
     OR (cm.memberId = :memberId)
    ORDER BY p.createdAt DESC
""")
    List<Payment> findByMemberId(@Param("memberId") Integer memberId);
}