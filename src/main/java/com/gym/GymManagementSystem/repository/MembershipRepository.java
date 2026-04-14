package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.dto.DashboardTopPackageItem;
import com.gym.GymManagementSystem.model.Membership;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface MembershipRepository extends JpaRepository<Membership, Integer> {

    Page<Membership> findByMember_FullnameContainingIgnoreCase(String fullname, Pageable pageable);

    Page<Membership> findByStatus(String status, Pageable pageable);

    Page<Membership> findByMember_FullnameContainingIgnoreCaseAndStatus(String fullname, String status, Pageable pageable);

    long countByStatus(String status);

    List<Membership> findAll(Sort sort);

    List<Membership> findByMemberMemberIdOrderByCreatedAtDesc(Integer memberId);

    Membership findTopByMemberMemberIdAndStatusOrderByStartDateDesc(Integer memberId, String status);

    Optional<Membership> findByMembershipId(Integer membershipId);

    Optional<Membership> findByMembershipIdAndMemberMemberId(Integer membershipId, Integer memberId);

    @Query("""
        select new com.gym.GymManagementSystem.dto.DashboardTopPackageItem(
            m.gymPackage.packageName,
            count(m)
        )
        from Membership m
        group by m.gymPackage.packageName
        order by count(m) desc
    """)
    List<DashboardTopPackageItem> findTopPackages(Pageable pageable);
}