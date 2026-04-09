package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PackageRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MembershipService {

    private final MembershipRepository membershipRepository;
    private final MemberRepository memberRepository;
    private final PackageRepository packageRepository;

    public MembershipService(MembershipRepository membershipRepository,
                             MemberRepository memberRepository,
                             PackageRepository packageRepository) {
        this.membershipRepository = membershipRepository;
        this.memberRepository = memberRepository;
        this.packageRepository = packageRepository;
    }

    public Page<Membership> searchMemberships(String keyword, String status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "membershipId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        if (hasKeyword && hasStatus) {
            return membershipRepository.findByMember_FullnameContainingIgnoreCaseAndStatus(keyword.trim(), status.trim(), pageable);
        }

        if (hasKeyword) {
            return membershipRepository.findByMember_FullnameContainingIgnoreCase(keyword.trim(), pageable);
        }

        if (hasStatus) {
            return membershipRepository.findByStatus(status.trim(), pageable);
        }

        return membershipRepository.findAll(pageable);
    }

    public Membership getMembershipById(Integer id) {
        return membershipRepository.findById(id).orElse(null);
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll(Sort.by(Sort.Direction.ASC, "fullname"));
    }

    public List<GymPackage> getAllPackages() {
        return packageRepository.findAll(Sort.by(Sort.Direction.ASC, "packageName"));
    }

    public Membership createMembership(Membership membership, Integer memberId, Integer packageId) {
        bindRelations(membership, memberId, packageId);
        validateDates(membership);

        if (membership.getStatus() == null || membership.getStatus().isBlank()) {
            membership.setStatus("PENDING");
        }

        return membershipRepository.save(membership);
    }

    public Membership updateMembership(Integer id, Membership formMembership, Integer memberId, Integer packageId) {
        Optional<Membership> optional = membershipRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Membership existing = optional.get();
        existing.setStartDate(formMembership.getStartDate());
        existing.setEndDate(formMembership.getEndDate());
        existing.setStatus(formMembership.getStatus());
        existing.setNote(formMembership.getNote());

        bindRelations(existing, memberId, packageId);
        validateDates(existing);

        return membershipRepository.save(existing);
    }

    public boolean softDeleteMembership(Integer id) {
        return membershipRepository.findById(id).map(existing -> {
            existing.setStatus("CANCELLED");
            membershipRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public long countPending() {
        return membershipRepository.countByStatus("PENDING");
    }

    public List<Membership> findPending() {
        return membershipRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public void approve(Integer id) {
        membershipRepository.findById(id).ifPresent(m -> {
            m.setStatus("ACTIVE");
            membershipRepository.save(m);
        });
    }

    public void reject(Integer id) {
        membershipRepository.findById(id).ifPresent(m -> {
            m.setStatus("REJECTED");
            membershipRepository.save(m);
        });
    }

    private void bindRelations(Membership membership, Integer memberId, Integer packageId) {
        Member member = memberId != null ? memberRepository.findById(memberId).orElse(null) : null;
        GymPackage gymPackage = packageId != null ? packageRepository.findById(packageId).orElse(null) : null;

        membership.setMember(member);
        membership.setGymPackage(gymPackage);
    }

    private void validateDates(Membership membership) {
        if (membership.getStartDate() != null
                && membership.getEndDate() != null
                && membership.getEndDate().isBefore(membership.getStartDate())) {
            throw new IllegalArgumentException("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }
    }
}