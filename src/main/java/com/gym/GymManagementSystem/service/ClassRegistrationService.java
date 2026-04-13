package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ClassRegistrationService {

    private final ClassRegistrationRepository repository;
    private final MemberRepository memberRepository;
    private final GymClassRepository gymClassRepository;
    private final ServiceRepository serviceRepository;
    private final PaymentRepository paymentRepository;
    private final NotificationService notificationService;

    public ClassRegistrationService(ClassRegistrationRepository repository,
                                    MemberRepository memberRepository,
                                    GymClassRepository gymClassRepository,
                                    ServiceRepository serviceRepository,
                                    PaymentRepository paymentRepository,
                                    NotificationService notificationService) {
        this.repository = repository;
        this.memberRepository = memberRepository;
        this.gymClassRepository = gymClassRepository;
        this.serviceRepository = serviceRepository;
        this.paymentRepository = paymentRepository;
        this.notificationService = notificationService;
    }

    public Page<ClassRegistration> searchRegistrations(String keyword, String status, Integer classId, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size > 0 ? size : 8,
                Sort.by(Sort.Direction.DESC, "registrationDate")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();
        boolean hasClass = classId != null;
        String kw = hasKeyword ? keyword.trim() : "";

        if (hasKeyword && hasClass && hasStatus) {
            return repository.findByMember_FullnameContainingIgnoreCaseAndGymClass_ClassIdAndStatus(
                    kw, classId, status.trim().toUpperCase(), pageable
            );
        }

        if (hasKeyword && hasStatus) {
            return repository.findByMember_FullnameContainingIgnoreCaseAndStatus(
                    kw, status.trim().toUpperCase(), pageable
            );
        }

        if (hasClass && hasStatus) {
            return repository.findByGymClass_ClassIdAndStatus(
                    classId, status.trim().toUpperCase(), pageable
            );
        }

        if (hasKeyword) {
            return repository.findByMember_FullnameContainingIgnoreCase(kw, pageable);
        }

        if (hasClass) {
            return repository.findByGymClass_ClassId(classId, pageable);
        }

        if (hasStatus) {
            return repository.findByStatus(status.trim().toUpperCase(), pageable);
        }

        return repository.findAll(pageable);
    }

    public ClassRegistration getRegistrationById(Integer id) {
        return repository.findById(id).orElse(null);
    }

    public ClassRegistration getById(Integer id) {
        return getRegistrationById(id);
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll(Sort.by(Sort.Direction.ASC, "fullname"));
    }

    public List<GymClass> getAllClasses() {
        return gymClassRepository.findAll(Sort.by(Sort.Direction.ASC, "className"));
    }

    public List<ServiceGym> getAllServices() {
        return serviceRepository.findAll(Sort.by(Sort.Direction.ASC, "serviceName"));
    }

    public ClassRegistration createRegistration(ClassRegistration registration, Integer memberId, Integer classId, Integer serviceId) {
        if (registration == null) {
            throw new IllegalArgumentException("Thông tin đăng ký lớp không hợp lệ");
        }

        bindRelations(registration, memberId, classId, serviceId);
        validateRelations(registration);

        registration.setRegistrationDate(
                registration.getRegistrationDate() != null ? registration.getRegistrationDate() : LocalDate.now()
        );

        if (registration.getStartDate() != null && registration.getStartDate().isBefore(registration.getRegistrationDate())) {
            throw new IllegalArgumentException("Ngày bắt đầu không được nhỏ hơn ngày đăng ký");
        }

        validateDates(registration);

        if (registration.getStatus() == null || registration.getStatus().isBlank()) {
            registration.setStatus("PENDING");
        } else {
            registration.setStatus(normalizeStatus(registration.getStatus()));
        }

        if ("ACTIVE".equalsIgnoreCase(registration.getStatus())) {
            throw new IllegalArgumentException("Không được tạo trực tiếp đăng ký lớp ở trạng thái ACTIVE");
        }

        ensureNoOpenRegistration(registration.getMember().getMemberId(), registration.getGymClass().getClassId(), null);

        ClassRegistration saved = repository.save(registration);
        syncClassCurrentMember(saved.getGymClass());

        notifyReceptionistForNewRegistration(saved);

        return saved;
    }

    public ClassRegistration updateRegistration(Integer id, ClassRegistration formRegistration, Integer memberId, Integer classId, Integer serviceId) {
        Optional<ClassRegistration> optional = repository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        ClassRegistration existing = optional.get();
        existing.setStartDate(formRegistration.getStartDate());
        existing.setEndDate(formRegistration.getEndDate());
        existing.setRegistrationDate(formRegistration.getRegistrationDate());
        existing.setStatus(normalizeStatus(formRegistration.getStatus()));
        existing.setNote(formRegistration.getNote());

        bindRelations(existing, memberId, classId, serviceId);
        validateRelations(existing);

        if (existing.getRegistrationDate() == null) {
            existing.setRegistrationDate(LocalDate.now());
        }

        if (existing.getStartDate() != null && existing.getStartDate().isBefore(existing.getRegistrationDate())) {
            throw new IllegalArgumentException("Ngày bắt đầu không được nhỏ hơn ngày đăng ký");
        }

        validateDates(existing);
        ensureNoOpenRegistration(existing.getMember().getMemberId(), existing.getGymClass().getClassId(), existing.getRegistrationId());

        if ("ACTIVE".equalsIgnoreCase(existing.getStatus())) {
            if (!hasPaidPayment(existing.getRegistrationId())) {
                throw new IllegalArgumentException("Không thể kích hoạt đăng ký lớp khi thanh toán chưa được xác nhận");
            }
            ensureCapacityForApproval(existing.getGymClass(), existing.getRegistrationId());
            if (existing.getStartDate() == null) {
                existing.setStartDate(LocalDate.now());
            }
        }

        ClassRegistration oldSnapshot = repository.findById(id).orElse(null);
        String oldStatus = oldSnapshot != null ? oldSnapshot.getStatus() : null;

        ClassRegistration saved = repository.save(existing);
        syncClassCurrentMember(saved.getGymClass());

        if (!equalsIgnoreCase(oldStatus, saved.getStatus())) {
            if ("ACTIVE".equalsIgnoreCase(saved.getStatus())) {
                notifyMemberApproved(saved);
                notifyTrainerNewMember(saved);
            } else if ("REJECTED".equalsIgnoreCase(saved.getStatus())) {
                notifyMemberRejected(saved);
            }
        }

        return saved;
    }

    public boolean cancelRegistration(Integer id) {
        Optional<ClassRegistration> optional = repository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        ClassRegistration registration = optional.get();
        registration.setStatus("CANCELLED");
        repository.save(registration);

        Payment payment = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"))
                .stream()
                .filter(p -> p.getClassRegistration() != null
                        && p.getClassRegistration().getRegistrationId() != null
                        && p.getClassRegistration().getRegistrationId().equals(registration.getRegistrationId()))
                .findFirst()
                .orElse(null);

        if (payment != null && !"PAID".equalsIgnoreCase(payment.getStatus())) {
            payment.setStatus("CANCELLED");
            paymentRepository.save(payment);
        }

        syncClassCurrentMember(registration.getGymClass());
        return true;
    }

    public List<ClassRegistration> findAll() {
        return repository.findAll(Sort.by(Sort.Direction.DESC, "registrationDate"));
    }

    public List<ClassRegistration> findCurrentRegistrationsByMemberId(Integer memberId) {
        if (memberId == null) {
            return List.of();
        }

        return repository.findAll(Sort.by(Sort.Direction.DESC, "registrationDate"))
                .stream()
                .filter(item -> item.getMember() != null && memberId.equals(item.getMember().getMemberId()))
                .filter(item -> "ACTIVE".equalsIgnoreCase(item.getStatus()))
                .toList();
    }

    public List<ClassRegistration> getByMember(Integer memberId) {
        if (memberId == null) {
            return List.of();
        }
        return repository.findByMemberMemberIdOrderByRegistrationDateDesc(memberId);
    }

    public long countActive() {
        return repository.countByStatus("ACTIVE");
    }

    public long countPending() {
        return repository.countByStatus("PENDING");
    }

    public List<ClassRegistration> findPending() {
        return repository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public List<ClassRegistration> findActiveByClassId(Integer classId) {
        return repository.findByGymClass_ClassIdAndStatus(classId, "ACTIVE");
    }

    public boolean isMemberActiveInClass(Integer memberId, Integer classId) {
        if (memberId == null || classId == null) {
            return false;
        }

        return repository.findByGymClass_ClassIdAndStatus(classId, "ACTIVE").stream()
                .anyMatch(r -> r.getMember() != null && r.getMember().getMemberId().equals(memberId));
    }

    public void approve(int id) {
        ClassRegistration registration = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký lớp"));

        if (!"PENDING".equalsIgnoreCase(registration.getStatus())) {
            throw new IllegalArgumentException("Chỉ có thể duyệt đăng ký lớp đang ở trạng thái PENDING");
        }

        if (!hasPaidPayment(registration.getRegistrationId())) {
            throw new IllegalArgumentException("Không thể duyệt đăng ký lớp khi chưa có thanh toán PAID");
        }

        ensureCapacityForApproval(registration.getGymClass(), registration.getRegistrationId());

        if (registration.getRegistrationDate() == null) {
            registration.setRegistrationDate(LocalDate.now());
        }

        if (registration.getStartDate() == null) {
            registration.setStartDate(LocalDate.now());
        }

        if (registration.getStartDate().isBefore(registration.getRegistrationDate())) {
            throw new IllegalArgumentException("Ngày bắt đầu không được nhỏ hơn ngày đăng ký");
        }

        validateDates(registration);

        registration.setStatus("ACTIVE");
        repository.save(registration);
        syncClassCurrentMember(registration.getGymClass());

        notifyMemberApproved(registration);
        notifyTrainerNewMember(registration);
    }

    public void reject(int id) {
        ClassRegistration registration = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký lớp"));

        if ("ACTIVE".equalsIgnoreCase(registration.getStatus())) {
            throw new IllegalArgumentException("Không thể từ chối đăng ký lớp đã ACTIVE");
        }

        registration.setStatus("REJECTED");
        repository.save(registration);
        syncClassCurrentMember(registration.getGymClass());

        notifyMemberRejected(registration);
    }

    public void activateFromPaidPayment(Integer registrationId) {
        // Giữ method này để tránh vỡ code cũ, nhưng không tự ACTIVE nữa.
    }

    private void bindRelations(ClassRegistration registration, Integer memberId, Integer classId, Integer serviceId) {
        Member member = memberId != null ? memberRepository.findById(memberId).orElse(null) : null;
        GymClass gymClass = classId != null ? gymClassRepository.findById(classId).orElse(null) : null;

        registration.setMember(member);
        registration.setGymClass(gymClass);

        if (gymClass != null) {
            registration.setService(gymClass.getService());
            return;
        }

        ServiceGym service = serviceId != null ? serviceRepository.findById(serviceId).orElse(null) : null;
        registration.setService(service);
    }

    private void validateRelations(ClassRegistration registration) {
        if (registration.getMember() == null) {
            throw new IllegalArgumentException("Vui lòng chọn hội viên");
        }
        if (registration.getGymClass() == null) {
            throw new IllegalArgumentException("Vui lòng chọn lớp học");
        }
        if (registration.getService() == null) {
            throw new IllegalArgumentException("Không tìm thấy dịch vụ của lớp học");
        }
    }

    private void validateDates(ClassRegistration registration) {
        if (registration.getRegistrationDate() == null) {
            throw new IllegalArgumentException("Ngày đăng ký không được để trống");
        }

        if (registration.getStartDate() != null
                && registration.getEndDate() != null
                && registration.getEndDate().isBefore(registration.getStartDate())) {
            throw new IllegalArgumentException("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }
    }

    private boolean hasPaidPayment(Integer registrationId) {
        if (registrationId == null) {
            return false;
        }

        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));
        return payments.stream()
                .anyMatch(p -> p.getClassRegistration() != null
                        && p.getClassRegistration().getRegistrationId() != null
                        && registrationId.equals(p.getClassRegistration().getRegistrationId())
                        && "PAID".equalsIgnoreCase(p.getStatus()));
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "PENDING";
        }

        String normalized = status.trim().toUpperCase();

        switch (normalized) {
            case "PENDING":
            case "ACTIVE":
            case "REJECTED":
            case "CANCELLED":
                return normalized;
            default:
                throw new IllegalArgumentException("Trạng thái đăng ký lớp không hợp lệ");
        }
    }

    private void syncClassCurrentMember(GymClass gymClass) {
        if (gymClass == null || gymClass.getClassId() == null) {
            return;
        }

        int activeCount = repository.findByGymClass_ClassIdAndStatus(gymClass.getClassId(), "ACTIVE").size();
        gymClass.setCurrentMember(activeCount);
        gymClassRepository.save(gymClass);
    }

    private void ensureCapacityForApproval(GymClass gymClass, Integer registrationId) {
        if (gymClass == null || gymClass.getClassId() == null) {
            throw new IllegalArgumentException("Không tìm thấy lớp học");
        }

        int activeCount = repository.findByGymClass_ClassIdAndStatus(gymClass.getClassId(), "ACTIVE").size();

        ClassRegistration current = registrationId != null ? repository.findById(registrationId).orElse(null) : null;
        boolean alreadyActive = current != null && "ACTIVE".equalsIgnoreCase(current.getStatus());

        if (!alreadyActive && activeCount >= gymClass.getMaxMember()) {
            throw new IllegalArgumentException("Lớp học đã đủ số lượng học viên");
        }
    }

    private void ensureNoOpenRegistration(Integer memberId, Integer classId, Integer excludeRegistrationId) {
        List<ClassRegistration> registrations = repository.findByMemberMemberIdOrderByRegistrationDateDesc(memberId);

        boolean existed = registrations.stream()
                .filter(item -> excludeRegistrationId == null || !excludeRegistrationId.equals(item.getRegistrationId()))
                .anyMatch(item -> item.getGymClass() != null
                        && item.getGymClass().getClassId() != null
                        && item.getGymClass().getClassId().equals(classId)
                        && ("PENDING".equalsIgnoreCase(item.getStatus())
                        || "ACTIVE".equalsIgnoreCase(item.getStatus())));

        if (existed) {
            throw new IllegalArgumentException("Hội viên đã có đăng ký đang chờ xử lý hoặc đang học ở lớp này");
        }
    }

    private void notifyReceptionistForNewRegistration(ClassRegistration registration) {
        if (registration == null || registration.getGymClass() == null) {
            return;
        }

        String memberName = registration.getMember() != null ? registration.getMember().getFullname() : "Hội viên";
        String className = registration.getGymClass().getClassName();

        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Đăng ký lớp mới",
                memberName + " vừa đăng ký lớp " + className,
                "/receptionist/class-registrations"
        );
    }

    private void notifyMemberApproved(ClassRegistration registration) {
        User memberUser = getMemberUser(registration);
        if (memberUser == null) {
            return;
        }

        notificationService.createNotification(
                memberUser.getUserId(),
                "Đăng ký lớp được duyệt",
                "Bạn đã được duyệt vào lớp " + getClassName(registration),
                "/member/schedules"
        );
    }

    private void notifyMemberRejected(ClassRegistration registration) {
        User memberUser = getMemberUser(registration);
        if (memberUser == null) {
            return;
        }

        notificationService.createNotification(
                memberUser.getUserId(),
                "Đăng ký lớp bị từ chối",
                "Đăng ký lớp " + getClassName(registration) + " đã bị từ chối",
                "/member/classes"
        );
    }

    private void notifyTrainerNewMember(ClassRegistration registration) {
        if (registration == null || registration.getGymClass() == null) {
            return;
        }

        Trainer trainer = registration.getGymClass().getTrainer();
        if (trainer == null || trainer.getStaff() == null || trainer.getStaff().getUser() == null) {
            return;
        }

        User trainerUser = trainer.getStaff().getUser();
        String memberName = registration.getMember() != null ? registration.getMember().getFullname() : "Học viên";

        notificationService.createNotification(
                trainerUser.getUserId(),
                "Có học viên mới trong lớp",
                memberName + " đã được duyệt vào lớp " + getClassName(registration),
                "/trainer/class-members?classId=" + registration.getGymClass().getClassId()
        );
    }

    private User getMemberUser(ClassRegistration registration) {
        if (registration == null || registration.getMember() == null) {
            return null;
        }
        return registration.getMember().getUser();
    }

    private String getClassName(ClassRegistration registration) {
        return registration != null && registration.getGymClass() != null && registration.getGymClass().getClassName() != null
                ? registration.getGymClass().getClassName()
                : "lớp học";
    }

    private boolean equalsIgnoreCase(String a, String b) {
        if (a == null && b == null) {
            return true;
        }
        if (a == null || b == null) {
            return false;
        }
        return a.equalsIgnoreCase(b);
    }
}