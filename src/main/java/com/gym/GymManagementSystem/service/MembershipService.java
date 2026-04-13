package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PackageRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class MembershipService {

    private final MembershipRepository membershipRepository;
    private final MemberRepository memberRepository;
    private final PackageRepository packageRepository;
    private final PaymentRepository paymentRepository;

    public MembershipService(MembershipRepository membershipRepository,
                             MemberRepository memberRepository,
                             PackageRepository packageRepository,
                             PaymentRepository paymentRepository) {
        this.membershipRepository = membershipRepository;
        this.memberRepository = memberRepository;
        this.packageRepository = packageRepository;
        this.paymentRepository = paymentRepository;
    }

    public Page<Membership> searchMemberships(String keyword, String status, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size > 0 ? size : 8,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        Page<Membership> result;

        if (hasKeyword && hasStatus) {
            result = membershipRepository.findByMember_FullnameContainingIgnoreCaseAndStatus(
                    keyword.trim(),
                    status.trim().toUpperCase(),
                    pageable
            );
        } else if (hasKeyword) {
            result = membershipRepository.findByMember_FullnameContainingIgnoreCase(
                    keyword.trim(),
                    pageable
            );
        } else if (hasStatus) {
            result = membershipRepository.findByStatus(
                    status.trim().toUpperCase(),
                    pageable
            );
        } else {
            result = membershipRepository.findAll(pageable);
        }

        result.getContent().forEach(this::attachPaymentStatusDisplay);
        return result;
    }

    public Membership getMembershipById(Integer id) {
        Membership membership = membershipRepository.findById(id).orElse(null);
        if (membership != null) {
            attachPaymentStatusDisplay(membership);
        }
        return membership;
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll(Sort.by(Sort.Direction.ASC, "fullname"));
    }

    public List<GymPackage> getAllPackages() {
        return packageRepository.findAll(Sort.by(Sort.Direction.ASC, "packageName"));
    }

    public Membership createMembership(Membership membership,
                                       Integer memberId,
                                       Integer packageId) {
        if (membership == null) {
            throw new IllegalArgumentException("Dữ liệu không hợp lệ");
        }

        Member member = memberId != null ? memberRepository.findById(memberId).orElse(null) : null;
        GymPackage gymPackage = packageId != null ? packageRepository.findById(packageId).orElse(null) : null;

        if (member == null) {
            throw new IllegalArgumentException("Vui lòng chọn hội viên");
        }
        if (gymPackage == null) {
            throw new IllegalArgumentException("Vui lòng chọn gói tập");
        }

        membership.setMember(member);
        membership.setGymPackage(gymPackage);
        membership.setNote(trimToNull(membership.getNote()));

        if (membership.getStartDate() == null) {
            membership.setStartDate(LocalDate.now());
        }

        if (membership.getEndDate() == null) {
            membership.setEndDate(membership.getStartDate().plusMonths(gymPackage.getDurationMonths()));
        }

        validateDates(membership);
        membership.setStatus("PENDING");

        Membership saved = membershipRepository.save(membership);
        attachPaymentStatusDisplay(saved);
        return saved;
    }

    public Membership updateMembership(Integer id,
                                       Membership formMembership,
                                       Integer memberId,
                                       Integer packageId) {
        Optional<Membership> optional = membershipRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Membership existing = optional.get();

        Member member = memberId != null ? memberRepository.findById(memberId).orElse(null) : null;
        GymPackage gymPackage = packageId != null ? packageRepository.findById(packageId).orElse(null) : null;

        if (member == null) {
            throw new IllegalArgumentException("Vui lòng chọn hội viên");
        }
        if (gymPackage == null) {
            throw new IllegalArgumentException("Vui lòng chọn gói tập");
        }

        existing.setMember(member);
        existing.setGymPackage(gymPackage);
        existing.setStartDate(formMembership.getStartDate());
        existing.setEndDate(formMembership.getEndDate());
        existing.setNote(trimToNull(formMembership.getNote()));

        validateDates(existing);

        String normalizedStatus = normalizeStatus(formMembership.getStatus());

        if ("ACTIVE".equals(normalizedStatus) && !hasPaidPayment(existing.getMembershipId())) {
            throw new IllegalArgumentException("Chưa có thanh toán PAID, không thể kích hoạt");
        }

        existing.setStatus(normalizedStatus);

        Membership saved = membershipRepository.save(existing);
        attachPaymentStatusDisplay(saved);
        return saved;
    }

    public void approve(Integer id) {
        Membership membership = membershipRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký"));

        if (!hasPaidPayment(membership.getMembershipId())) {
            throw new IllegalArgumentException("Chưa có thanh toán PAID, không thể duyệt");
        }

        membership.setStatus("ACTIVE");
        membershipRepository.save(membership);
    }

    public void reject(Integer id) {
        Membership membership = membershipRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký"));

        membership.setStatus("REJECTED");
        membershipRepository.save(membership);
    }

    public boolean softDeleteMembership(Integer id) {
        Optional<Membership> optional = membershipRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        Membership membership = optional.get();
        membership.setStatus("CANCELLED");
        membershipRepository.save(membership);
        return true;
    }

    public long countPending() {
        return membershipRepository.countByStatus("PENDING");
    }

    public List<Membership> findPending() {
        List<Membership> items = membershipRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
        items.forEach(this::attachPaymentStatusDisplay);
        return items;
    }

    public void activateFromPaidPayment(Integer membershipId) {
        // Giữ lại để không vỡ code cũ
    }

    public void attachCurrentMembershipSummary(Member member) {
        if (member == null || member.getMemberId() == null) {
            return;
        }

        List<Membership> memberships = membershipRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));

        Membership current = memberships.stream()
                .filter(m -> m.getMember() != null && member.getMemberId().equals(m.getMember().getMemberId()))
                .filter(m -> "ACTIVE".equalsIgnoreCase(m.getStatus()) || "PENDING".equalsIgnoreCase(m.getStatus()))
                .findFirst()
                .orElse(null);

        if (current == null) {
            member.setCurrentPackageName(null);
            member.setCurrentMembershipStatus(null);
            member.setCurrentMembershipEndDate(null);
            return;
        }

        member.setCurrentPackageName(
                current.getGymPackage() != null ? current.getGymPackage().getPackageName() : null
        );
        member.setCurrentMembershipStatus(current.getStatus());
        member.setCurrentMembershipEndDate(
                current.getEndDate() != null ? current.getEndDate().toString() : null
        );
    }

    private boolean hasPaidPayment(Integer membershipId) {
        if (membershipId == null) {
            return false;
        }

        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        return payments.stream()
                .anyMatch(p -> p.getMembership() != null
                        && p.getMembership().getMembershipId() != null
                        && membershipId.equals(p.getMembership().getMembershipId())
                        && "PAID".equalsIgnoreCase(p.getStatus()));
    }

    private void attachPaymentStatusDisplay(Membership membership) {
        if (membership == null || membership.getMembershipId() == null) {
            return;
        }

        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        Payment latest = payments.stream()
                .filter(p -> p.getMembership() != null
                        && p.getMembership().getMembershipId() != null
                        && membership.getMembershipId().equals(p.getMembership().getMembershipId()))
                .findFirst()
                .orElse(null);

        if (latest == null) {
            membership.setPaymentStatusDisplay("CHƯA THANH TOÁN");
            return;
        }

        String paymentStatus = latest.getStatus() == null ? "" : latest.getStatus().toUpperCase();

        switch (paymentStatus) {
            case "PAID":
                membership.setPaymentStatusDisplay("ĐÃ THANH TOÁN");
                break;
            case "PENDING":
                membership.setPaymentStatusDisplay("CHỜ DUYỆT");
                break;
            case "REJECTED":
                membership.setPaymentStatusDisplay("BỊ TỪ CHỐI");
                break;
            case "CANCELLED":
                membership.setPaymentStatusDisplay("ĐÃ HỦY");
                break;
            default:
                membership.setPaymentStatusDisplay(latest.getStatus());
                break;
        }
    }

    private void validateDates(Membership membership) {
        if (membership.getStartDate() == null) {
            throw new IllegalArgumentException("Ngày bắt đầu không được để trống");
        }

        if (membership.getEndDate() == null) {
            throw new IllegalArgumentException("Ngày kết thúc không được để trống");
        }

        if (membership.getEndDate().isBefore(membership.getStartDate())) {
            throw new IllegalArgumentException("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu");
        }
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "PENDING";
        }

        String s = status.trim().toUpperCase();

        switch (s) {
            case "PENDING":
            case "ACTIVE":
            case "REJECTED":
            case "CANCELLED":
            case "EXPIRED":
                return s;
            default:
                throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}