package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Membership;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MembershipRepository extends JpaRepository<Membership, Long> {
    long countByStatus(String status);

    @Query("""
        SELECT m
        FROM Membership m
        WHERE
            (:keyword IS NULL OR :keyword = '' OR
             LOWER(COALESCE(m.memberName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(m.packageName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
        AND
            (:status IS NULL OR :status = '' OR m.status = :status)
    """)
    Page<Membership> searchMemberships(@Param("keyword") String keyword,
                                       @Param("status") String status,
                                       Pageable pageable);
}