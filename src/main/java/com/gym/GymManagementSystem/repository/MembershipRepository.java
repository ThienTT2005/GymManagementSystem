package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Membership;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface MembershipRepository extends JpaRepository<Membership, Integer> {

    // Lấy membership active mới nhất
    @Query("SELECT m FROM Membership m " +
            "WHERE m.member.memberId = :memberId " +
            "AND m.status IN ('active') " +
            "AND m.endDate > CURRENT_DATE " +
            "ORDER BY m.createdAt DESC")
    List<Membership> findActiveByMemberId(@Param("memberId") Integer memberId);

    @Query("SELECT m FROM Membership m " +
            "WHERE m.member.memberId = :memberId " +
            "AND m.status IN ('pending') " +
            "AND m.endDate > CURRENT_DATE " +
            "ORDER BY m.createdAt DESC")
    List<Membership> findPendingByMemberId(@Param("memberId") Integer memberId);

    Optional<Membership> findByMembershipId(Integer membershipId);

    Optional<Membership> findByMembershipIdAndMemberMemberId(
            Integer membershipId, Integer memberId);

    // Toàn bộ lịch sử
    List<Membership> findByMemberMemberIdOrderByCreatedAtDesc(Integer memberId);
}