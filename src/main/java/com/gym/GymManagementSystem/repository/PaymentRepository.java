package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    Optional<Payment> findTopByMembershipMembershipIdOrderByCreatedAtDesc(Integer membershipId);

    @Query("SELECT p FROM Payment p " +
            "WHERE p.membership.user.userId = :userId " +
            "ORDER BY p.createdAt DESC")
    List<Payment> findByUserId(@Param("userId") Integer userId);
}