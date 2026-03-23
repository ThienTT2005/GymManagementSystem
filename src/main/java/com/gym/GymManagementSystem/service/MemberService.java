package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.*;
import com.gym.GymManagementSystem.model.Package;
import com.gym.GymManagementSystem.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

// @Service: đánh dấu đây là Service, Spring sẽ quản lý object này
// @RequiredArgsConstructor (Lombok): tự tạo constructor inject tất cả final field
//   → thay cho @Autowired trên từng field
@Service
@RequiredArgsConstructor
public class MemberService {

    // Spring tự inject — không cần "new ClubRepository()"
    private final ClubRepository clubRepository;
    private final PackageRepository packageRepository;
    private final MembershipRepository membershipRepository;
    private final PaymentRepository paymentRepository;
    private final ScheduleRepository scheduleRepository;
    private final ClassRegistrationRepository classRegRepository;
    private final UserRepository userRepository;

    // ========== CLUB ==========

    public List<Club> getAllClubs() {
        return clubRepository.findAll();
    }

//    public Club getClubById(int clubId) {
//        return clubRepository.findById(clubId).orElse(null);
//        // orElse(null): nếu không tìm thấy → trả về null thay vì throw exception
//    }

    // ========== PACKAGE ==========

    public List<Package> getAllActivePackages() {
        return packageRepository.findByStatusOrderByPrice("active");
    }

    public Package getPackageById(int packageId) {
        return packageRepository.findById(packageId).orElse(null);
    }

    // ========== MEMBERSHIP ==========

    // @Transactional: nếu có lỗi giữa chừng → tự rollback, không lưu dở dang
    @Transactional
    public int registerPackage(int userId, int packageId) {
        // Kiểm tra đã có gói active/pending chưa
        List<Membership> existing = membershipRepository.findActiveByUserId(userId);
        if (!existing.isEmpty()) return -2;

        Package pkg = packageRepository.findById(packageId).orElse(null);
        if (pkg == null) return -1;

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return -1;

        Membership m = new Membership();
        m.setUser(user);       // set object User, không phải userId
        m.setPkg(pkg);
        m.setStartDate(LocalDate.now());
        m.setEndDate(LocalDate.now().plusMonths(pkg.getDurationMonth()));

        Membership saved = membershipRepository.save(m); // save = INSERT nếu mới
        return saved.getMembershipId();
    }

    @Transactional
    public int renewPackage(int userId, int packageId) {
        Package pkg = packageRepository.findById(packageId).orElse(null);
        if (pkg == null) return -1;

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return -1;

        List<Membership> actives = membershipRepository.findActiveByUserId(userId);
        LocalDate newStart;

        if (!actives.isEmpty()) {
            Membership current = actives.get(0);
            if (current.getEndDate() != null && current.getEndDate().isAfter(LocalDate.now())) {
                newStart = current.getEndDate().plusDays(1);
            } else {
                newStart = LocalDate.now();
            }
        } else {
            newStart = LocalDate.now();
        }

        Membership m = new Membership();
        m.setUser(user);
        m.setPkg(pkg);
        m.setStartDate(newStart);
        m.setEndDate(newStart.plusMonths(pkg.getDurationMonth()));

        Membership saved = membershipRepository.save(m);
        return saved.getMembershipId();
    }

    public Membership getActiveMembership(int userId) {
        List<Membership> list = membershipRepository.findActiveByUserId(userId);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Membership> getMembershipHistory(int userId) {
        return membershipRepository.findByUserUserIdOrderByCreatedAtDesc(userId);
    }

    // ========== PAYMENT ==========

    @Transactional
    public boolean createPayment(int membershipId, BigDecimal amount) {
        Membership membership = membershipRepository.findById(membershipId).orElse(null);
        if (membership == null) return false;

        Payment payment = new Payment();
        payment.setMembership(membership);
        payment.setAmount(amount);
        paymentRepository.save(payment);
        return true;
    }

    @Transactional
    public boolean uploadProofImage(int membershipId, MultipartFile file, String uploadDir)
            throws IOException {
        Payment payment = paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId)
                .orElse(null);
        if (payment == null || file.isEmpty()) return false;

        // Tạo thư mục nếu chưa có
        Path dir = Paths.get(uploadDir, "payments");
        Files.createDirectories(dir);

        // Lưu file với tên UUID
        String ext = "";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }
        String fileName = UUID.randomUUID() + ext;
        Files.copy(file.getInputStream(), dir.resolve(fileName),
                StandardCopyOption.REPLACE_EXISTING);

        payment.setProofImage("/uploads/payments/" + fileName);
        paymentRepository.save(payment); // save = UPDATE vì đã có ID
        return true;
    }

    public Payment getPaymentByMembershipId(int membershipId) {
        return paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId)
                .orElse(null);
    }

    public List<Payment> getPaymentHistory(int userId) {
        return paymentRepository.findByUserId(userId);
    }

    // ========== SCHEDULE ==========

    public List<ScheduleDTO> getAllSchedules() {
        List<Schedule> schedules = scheduleRepository.findByStatus("active");

        List<ScheduleDTO> result = new ArrayList<>();
        for (Schedule sch : schedules) {
            result.add(new ScheduleDTO(
                    sch,
                    classRegRepository.countByScheduleScheduleIdAndStatus(
                            sch.getScheduleId(), "active")
            ));
        }
        return result;
    }

    public List<ScheduleDTO> getSchedulesByClub(int clubId) {
        List<Schedule> schedules = scheduleRepository.findByClubClubIdAndStatus(clubId, "active");

        List<ScheduleDTO> result = new ArrayList<>();
        for (Schedule sch : schedules) {
            result.add(new ScheduleDTO(
                    sch,
                    classRegRepository.countByScheduleScheduleIdAndStatus(
                            sch.getScheduleId(), "active")
            ));
        }
        return result;
    }

//    public Schedule getScheduleById(int scheduleId) {
//        return scheduleRepository.findById(scheduleId).orElse(null);
//    }
//
//    public long countRegistered(int scheduleId) {
//        return classRegRepository.countByScheduleScheduleIdAndStatus(scheduleId, "active");
//    }

    // ========== CLASS REGISTRATION ==========

    @Transactional
    public int registerClass(int userId, int scheduleId) {
        // Đã đăng ký chưa?
        if (classRegRepository.existsByUserUserIdAndScheduleScheduleIdAndStatus(
                userId, scheduleId, "active")) return -2;

        Schedule schedule = scheduleRepository.findById(scheduleId).orElse(null);
        if (schedule == null) return -1;

        // Còn chỗ không?
        long registered = classRegRepository.countByScheduleScheduleIdAndStatus(scheduleId, "active");
        if (registered >= schedule.getMaxMember()) return -3;

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return -1;

        ClassRegistration cr = new ClassRegistration();
        cr.setUser(user);
        cr.setSchedule(schedule);
        classRegRepository.save(cr);
        return 0;
    }

    @Transactional
    public boolean cancelClass(int registrationId, int userId) {
        ClassRegistration cr = classRegRepository.findById(registrationId).orElse(null);
        if (cr == null || !cr.getUser().getUserId().equals(userId)) return false;
        cr.setStatus("cancelled");
        classRegRepository.save(cr);
        return true;
    }

    public List<ClassRegistration> getMyClasses(int userId) {
        return classRegRepository.findByUserUserIdOrderByCreatedAtDesc(userId);
    }

    // ========== USER PROFILE ==========

    public User getProfile(int userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public String updateProfile(int userId, String fullName, String email,
                                String phone, String address) {
        if (userRepository.existsByEmailAndUserIdNot(email, userId)) {
            return "Email đã được sử dụng bởi tài khoản khác.";
        }
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return "Không tìm thấy tài khoản.";

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        userRepository.save(user);
        return null; // null = không có lỗi
    }
}
