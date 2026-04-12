package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.*;
import com.gym.GymManagementSystem.model.Package;
import com.gym.GymManagementSystem.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final PackageRepository packageRepository;
    private final GymClassRepository gymClassRepository;
    private final ScheduleRepository scheduleRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;
    private final PaymentRepository paymentRepository;

    // ========== MEMBER PROFILE ==========

    public Member getProfile(Integer userId) {
        return memberRepository.findByUserUserId(userId).orElse(null);
    }

    @Transactional
    public String updateProfile(Integer userId, String fullname, String email,
                                String phone, String address,
                                String gender, LocalDate dob, MultipartFile avatar) throws IOException {
        Member member = memberRepository.findByUserUserId(userId).orElse(null);
        if (member == null) return "Không tìm thấy hồ sơ.";

        member.setFullname(fullname);
        member.setEmail(email);
        member.setPhone(phone);
        member.setAddress(address);
        member.setGender(gender);
        member.setDob(dob);

        if (avatar != null && !avatar.isEmpty()) {
            try {
                String fileName = System.currentTimeMillis() + "_" + avatar.getOriginalFilename();

                String uploadDir = System.getProperty("user.dir") + "/uploads/memberavt/";
                File uploadPath = new File(uploadDir);

                if (!uploadPath.exists()) {
                    uploadPath.mkdirs();
                }

                avatar.transferTo(new File(uploadDir + fileName));

                member.setAvatar("memberavt/" + fileName);

            } catch (IOException e) {
                return "Upload avatar thất bại.";
            }
        }
        memberRepository.save(member);
        return null; // null = thành công
    }

    // ========== PACKAGE ==========

    public List<Package> getAllActivePackages() {
        return packageRepository.findByStatusOrderByPrice("active");
    }


    public Package getPackageById(Integer packageId) {
        return packageRepository.findById(packageId).orElse(null);
    }

    // ========== CLASS & SCHEDULE ==========

    public Classes getClassesById(Integer classId) {return gymClassRepository.findById(classId).orElse(null);}

    public List<Classes> getAllActiveClasses() {
        return gymClassRepository.findByStatus("active");
    }

    public List<Schedule> getAllActiveSchedules() {
        return scheduleRepository.findByStatus("active");
    }

    // Lấy lịch tập của 1 lớp
    public List<Schedule> getSchedulesByClass(Integer classId) {
        return scheduleRepository.findByClassesClassIdAndStatus(classId, "active");
    }
    // Lấy lịch học của các lớp member đã đăng ký (status = active, pending)
    public List<ClassRegistration> getMyActivePendingClasses(Integer memberId) {
        return classRegistrationRepository
                .findActiveByMemberId(memberId);
    }


    // ========== MEMBERSHIP ==========
    public Membership getActiveMembership(Integer memberId) {
        List<Membership> list = membershipRepository.findActiveByMemberId(memberId);
        return list.isEmpty() ? null : list.get(0);
    }

    public Membership getPendingMembership(Integer memberId) {
        List<Membership> list = membershipRepository.findPendingByMemberId(memberId);
        return list.isEmpty() ? null : list.get(0);
    }

    public Membership getMembershipByMembershipId(Integer membershipId) {
        return membershipRepository.findByMembershipId(membershipId).orElse(null);
    }

    public List<Membership> getMembershipHistory(Integer memberId) {
        return membershipRepository.findByMemberMemberIdOrderByCreatedAtDesc(memberId);
    }

    @Transactional
    public int registerMembership(Integer memberId, Integer packageId) {
        List<Membership> existing = membershipRepository.findActiveByMemberId(memberId);
        if (!existing.isEmpty()) return -2;
        List<Membership> pend = membershipRepository.findPendingByMemberId(memberId);
        if (!pend.isEmpty()) return -3;

        Package pkg = packageRepository.findById(packageId).orElse(null);
        Member member = memberRepository.findById(memberId).orElse(null);
        if (pkg == null || member == null) return -1;

        Membership ms = new Membership();
        ms.setMember(member);
        ms.setPkg(pkg);
        ms.setStartDate(LocalDate.now());
        ms.setEndDate(LocalDate.now().plusMonths(pkg.getDurationMonth()));
        return membershipRepository.save(ms).getMembershipId();
    }

    @Transactional
    public int renewMembership(Integer memberId, Integer packageId) {
        Package pkg = packageRepository.findById(packageId).orElse(null);
        Member member = memberRepository.findById(memberId).orElse(null);
        if (pkg == null || member == null) return -1;
        List<Membership> pend = membershipRepository.findPendingByMemberId(memberId);
        if (!pend.isEmpty()) return -3;

        List<Membership> actives = membershipRepository.findActiveByMemberId(memberId);
        LocalDate newStart;
        if (!actives.isEmpty()
                && actives.get(0).getEndDate() != null
                && actives.get(0).getEndDate().isAfter(LocalDate.now())) {
            newStart = actives.get(0).getEndDate().plusDays(1);
        } else {
            newStart = LocalDate.now();
        }

        Membership ms = new Membership();
        ms.setMember(member);
        ms.setPkg(pkg);
        ms.setStartDate(newStart);
        ms.setEndDate(newStart.plusMonths(pkg.getDurationMonth()));
        return membershipRepository.save(ms).getMembershipId();
    }

    // ========== PAYMENT ==========

    @Transactional
    public boolean createPayment(Integer membershipId, Integer classRegistrationId, BigDecimal amount) {
        Payment payment = new Payment();
        if(membershipId != null) {
            Membership ms = membershipRepository.findById(membershipId).orElse(null);
            if (ms != null) payment.setMembership(ms);
        }
        if(classRegistrationId != null){
            ClassRegistration cr = classRegistrationRepository.findById(classRegistrationId).orElse(null);
            if (cr != null) payment.setClassRegistration(cr);
        }

        payment.setAmount(amount);
        payment.setPaymentMethod("Chuyển khoản");
        paymentRepository.save(payment);
        return true;
    }

    @Transactional
    public boolean uploadPaymentProof(Integer membershipId, Integer classRegistrationId, MultipartFile file, String uploadDir)
            throws IOException {
        Payment payment = null;
        if(membershipId != null) {
            payment = paymentRepository
                    .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId)
                    .orElse(null);
        }
        if(classRegistrationId != null){
            payment = paymentRepository
                    .findTopByClassRegistrationClassRegistrationIdOrderByCreatedAtDesc(classRegistrationId)
                    .orElse(null);
        }

        if (payment == null || file.isEmpty()) return false;

        Path dir = Paths.get(uploadDir, "payments");
        Files.createDirectories(dir);

        String original = file.getOriginalFilename();
        String ext = (original != null && original.contains("."))
                ? original.substring(original.lastIndexOf('.')) : "";
        String fileName = UUID.randomUUID() + ext;
        Files.copy(file.getInputStream(), dir.resolve(fileName),
                StandardCopyOption.REPLACE_EXISTING);

        payment.setProofImage("/uploads/payments/" + fileName);
        paymentRepository.save(payment);
        return true;
    }

    public Payment getPaymentByMembershipId(Integer membershipId) {
        return paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId)
                .orElse(null);
    }

    public Payment getPaymentByClassRegistrationId(Integer classRegistrationId) {
        return paymentRepository
                .findTopByClassRegistrationClassRegistrationIdOrderByCreatedAtDesc(classRegistrationId).orElse(null);
    }

    public List<Payment> getPaymentHistory(Integer memberId) {
        return paymentRepository.findByMemberId(memberId);
    }

    public List<ClassRegistration> getClassRegistrationHistory(Integer memberId) {
        return classRegistrationRepository
                .findByMemberMemberIdOrderByCreatedAtDesc(memberId);
    }

    // ========== Register%Cancel class ==========

    @Transactional
    public int registerClass(Integer memberId, Integer classId) {
        // Kiểm tra đã đăng ký lớp này chưa (status khác cancelled)
        boolean existed = classRegistrationRepository
                .existsByMemberMemberIdAndClassesClassIdAndStatusNot(
                        memberId, classId, "cancelled");
        if (existed) return -2; // đã đăng ký rồi

        Classes gymClass = gymClassRepository.findById(classId).orElse(null);
        Member member = memberRepository.findById(memberId).orElse(null);
        if (gymClass == null || member == null) return -1;

        // Kiểm tra còn chỗ không
        if (gymClass.getCurentmember() >= gymClass.getMaxmember()) return -3;

        // Tạo class registration
        ClassRegistration cr = new ClassRegistration();
        cr.setMember(member);
        cr.setClasses(gymClass);
        cr.setService(gymClass.getService());
        cr.setStartDate(LocalDate.now());
        cr.setStatus("pending");


        // Cập nhật số lượng current_member trong lớp
        gymClass.setCurentmember(gymClass.getCurentmember() + 1);
        gymClassRepository.save(gymClass);

        return classRegistrationRepository.save(cr).getClassRegistrationId();
    }

    public ClassRegistration getClassRegistrationByClassRegistrationId(Integer classRegistrationId) {
        return classRegistrationRepository.findByClassRegistrationId(classRegistrationId).orElse(null);
    }

    @Transactional
    public boolean cancelClass(Integer classRegistrationId, Integer memberId) {
        ClassRegistration cr = classRegistrationRepository
                .findByClassRegistrationIdAndMemberMemberId(classRegistrationId, memberId)
                .orElse(null);
        if (cr == null) return false;
        if ("cancelled".equals(cr.getStatus())) return false; // đã huỷ rồi

        cr.setStatus("cancelled");
        classRegistrationRepository.save(cr);

        Payment p = paymentRepository
                .findTopByClassRegistrationClassRegistrationIdOrderByCreatedAtDesc(classRegistrationId).orElse(null);
        p.setStatus("cancelled");
        paymentRepository.save(p);

        // Giảm số lượng current_member trong lớp
        Classes gymClass = cr.getClasses();
        if (gymClass.getCurentmember() > 0) {
            gymClass.setCurentmember(gymClass.getCurentmember() - 1);
            gymClassRepository.save(gymClass);
        }
        return true;
    }

// ========== HUỶ MEMBERSHIP ==========

    @Transactional
    public boolean cancelMembership(Integer membershipId, Integer memberId) {
        Membership ms = membershipRepository
                .findByMembershipIdAndMemberMemberId(membershipId, memberId)
                .orElse(null);
        if (ms == null) return false;

        // Chỉ cho huỷ khi đang pending (chưa được duyệt)
        // Nếu đã active thì không cho huỷ
        if (!"pending".equals(ms.getStatus())) return false;

        ms.setStatus("cancelled");
        Payment p = paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId).orElse(null);
        if (p == null) return false;
        p.setStatus("cancelled");

        paymentRepository.save(p);
        membershipRepository.save(ms);
        return true;
    }
}