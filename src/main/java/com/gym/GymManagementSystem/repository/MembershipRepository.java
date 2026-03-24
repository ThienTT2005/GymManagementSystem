package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Membership;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface MembershipRepository extends JpaRepository<Membership, Integer> {

    @Query("SELECT m FROM Membership m " +
            "WHERE m.user.userId = :userId " +
            "AND m.status IN ('active', 'pending') " +
            "ORDER BY m.createdAt DESC")
    List<Membership> findActiveByUserId(@Param("userId") Integer userId);

    List<Membership> findByUserUserIdOrderByCreatedAtDesc(Integer userId);
}