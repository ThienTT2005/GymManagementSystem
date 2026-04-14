package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.config.UploadConfig;
import com.gym.GymManagementSystem.model.*;
import com.gym.GymManagementSystem.repository.*;
import com.gym.GymManagementSystem.util.PasswordUtil;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
public class MemberService {

    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\-\\s]{9,15}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private final MemberRepository memberRepository;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;
    private final PaymentRepository paymentRepository;
    private final GymClassRepository gymClassRepository;
    private final PackageRepository packageRepository;
    private final UploadConfig uploadConfig;
    private final NotificationService notificationService;
    private final ScheduleRepository scheduleRepository;

    public MemberService(MemberRepository memberRepository,
                         UserRepository userRepository,
                         RoleRepository roleRepository,
                         MembershipRepository membershipRepository,
                         ClassRegistrationRepository classRegistrationRepository,
                         PaymentRepository paymentRepository,
                         GymClassRepository gymClassRepository,
                         PackageRepository packageRepository,
                         UploadConfig uploadConfig,
                         NotificationService notificationService, ScheduleRepository scheduleRepository) {
        this.memberRepository = memberRepository;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
        this.paymentRepository = paymentRepository;
        this.gymClassRepository = gymClassRepository;
        this.packageRepository = packageRepository;
        this.uploadConfig = uploadConfig;
        this.notificationService = notificationService;
        this.scheduleRepository = scheduleRepository;
    }

    public Page<Member> searchMembers(String keyword, Integer status, int page, int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;
        String normalizedKeyword = trimToNull(keyword);

        List<Member> filteredMembers = memberRepository.findAll().stream()
                .filter(member -> matchKeyword(member, normalizedKeyword))
                .filter(member -> status == null || status.equals(member.getStatus()))
                .sorted(memberNameComparator())
                .toList();

        int fromIndex = Math.min(safePage * safeSize, filteredMembers.size());
        int toIndex = Math.min(fromIndex + safeSize, filteredMembers.size());
        List<Member> pagedMembers = filteredMembers.subList(fromIndex, toIndex);

        return new PageImpl<>(pagedMembers, PageRequest.of(safePage, safeSize), filteredMembers.size());
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll().stream()
                .sorted(memberNameComparator())
                .toList();
    }

    public long countMembers() {
        return memberRepository.count();
    }

    public Member getMemberById(Integer id) {
        if (id == null) {
            return null;
        }
        return memberRepository.findById(id).orElse(null);
    }

    @Transactional
    public Member createMemberWithAccount(Member member, String username, String password) {
        if (member == null) {
            throw new IllegalArgumentException("Thông tin hội viên không hợp lệ");
        }

        normalizeMember(member);
        validateMember(member);

        String normalizedUsername = normalizeUsername(username);
        validatePassword(password);

        if (userRepository.existsByUsername(normalizedUsername)) {
            throw new IllegalArgumentException("Username đã tồn tại");
        }

        Role memberRole = resolveMemberRole();

        User user = new User();
        user.setUsername(normalizedUsername);
        user.setPassword(PasswordUtil.hash(password.trim()));
        user.setRole(memberRole);
        user.setStatus(member.getStatus() == null ? 1 : member.getStatus());

        User savedUser = userRepository.save(user);

        if (member.getStatus() == null) {
            member.setStatus(1);
        }

        applyAvatarDefault(member);
        member.setUser(savedUser);

        return memberRepository.save(member);
    }

    @Transactional
    public Member createMember(Member member, Integer userId) {
        if (member == null) {
            throw new IllegalArgumentException("Thông tin hội viên không hợp lệ");
        }

        normalizeMember(member);
        validateMember(member);

        if (member.getStatus() == null) {
            member.setStatus(1);
        }

        applyAvatarDefault(member);
        bindUser(member, userId, null);

        return memberRepository.save(member);
    }

    @Transactional
    public Member createMember(Member member) {
        return createMember(member, null);
    }

    @Transactional
    public Member updateMember(Integer id, Member formMember, Integer userId) {
        if (id == null || formMember == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }

        Optional<Member> optional = memberRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Member existing = optional.get();

        normalizeMember(formMember);
        validateMember(formMember);

        existing.setFullname(formMember.getFullname());
        existing.setPhone(formMember.getPhone());
        existing.setEmail(formMember.getEmail());
        existing.setAddress(formMember.getAddress());
        existing.setGender(formMember.getGender());
        existing.setDob(formMember.getDob());
        existing.setStatus(formMember.getStatus());

        if (hasText(formMember.getAvatar())) {
            existing.setAvatar(formMember.getAvatar().trim());
        } else if (!hasText(existing.getAvatar())) {
            existing.setAvatar(defaultAvatar());
        }

        if (userId != null) {
            bindUser(existing, userId, id);
        }

        return memberRepository.save(existing);
    }

    @Transactional
    public Member updateMember(Member member) {
        if (member == null || member.getMemberId() == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }
        return updateMember(member.getMemberId(), member, null);
    }

    public boolean deleteMember(Integer id) {
        return softDeleteMember(id);
    }

    @Transactional
    public boolean softDeleteMember(Integer id) {
        if (id == null) {
            return false;
        }

        return memberRepository.findById(id).map(existing -> {
            existing.setStatus(0);
            memberRepository.save(existing);
            return true;
        }).orElse(false);
    }

    @Transactional
    public void updateStatus(Integer memberId, Integer status) {
        if (memberId == null) {
            throw new IllegalArgumentException("Không tìm thấy hội viên");
        }

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hội viên"));

        member.setStatus(status);
        memberRepository.save(member);
    }

    public boolean existsByUserId(Integer userId, Integer excludeMemberId) {
        if (userId == null) {
            return false;
        }

        if (excludeMemberId == null) {
            return memberRepository.existsByUser_UserId(userId);
        }

        return memberRepository.existsByUser_UserIdAndMemberIdNot(userId, excludeMemberId);
    }

    public List<User> getAssignableUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"))
                .stream()
                .filter(this::isMemberRoleUser)
                .filter(User::isActive)
                .filter(user -> !memberRepository.existsByUser_UserId(user.getUserId()))
                .toList();
    }

    public List<User> getAssignableUsers(Integer excludeMemberId) {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"))
                .stream()
                .filter(this::isMemberRoleUser)
                .filter(User::isActive)
                .filter(user -> {
                    if (excludeMemberId == null) {
                        return !memberRepository.existsByUser_UserId(user.getUserId());
                    }
                    return !memberRepository.existsByUser_UserIdAndMemberIdNot(user.getUserId(), excludeMemberId);
                })
                .toList();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"));
    }

    public Member getProfile(Integer userId) {
        return memberRepository.findByUserUserId(userId).orElse(null);
    }

    @Transactional
    public String updateProfile(Integer userId,
                                String fullName,
                                String email,
                                String phone,
                                String address,
                                String gender,
                                LocalDate dob,
                                MultipartFile avatar) throws IOException {
        Member member = memberRepository.findByUserUserId(userId).orElse(null);
        if (member == null) {
            return "Không tìm thấy hồ sơ.";
        }

        member.setFullname(trimToNull(fullName));
        member.setEmail(trimToNull(email));
        member.setPhone(trimToNull(phone));
        member.setAddress(trimToNull(address));
        member.setGender(normalizeGender(gender));
        member.setDob(dob);

        String validationError = validateProfile(member);
        if (validationError != null) {
            return validationError;
        }

        if (avatar != null && !avatar.isEmpty()) {
            String originalName = avatar.getOriginalFilename();
            String ext = "";

            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf('.'));
            }

            String fileName = System.currentTimeMillis() + "_" + UUID.randomUUID() + ext;
            Path uploadPath = Paths.get(uploadConfig.getUploadDir(), "memberavt").toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);
            Files.copy(avatar.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);

            member.setAvatar("memberavt/" + fileName);
        }

        memberRepository.save(member);
        return null;
    }

    public List<GymPackage> getAllActivePackages() {
        return packageRepository.findAllByStatus(1);
    }

    public GymPackage getPackageById(Integer id) {
        return packageRepository.findById(id).orElse(null);
    }

    public List<GymClass> getAllActiveClasses() {
        List<GymClass> classes = gymClassRepository.findAll().stream()
                .filter(c -> c.getStatus() != null && c.getStatus() == 1)
                .toList();

        classes.forEach(this::syncClassCurrentMember);
        return classes;
    }

    public GymClass getClassesById(Integer id) {
        GymClass gymClass = gymClassRepository.findById(id).orElse(null);
        if (gymClass != null) {
            syncClassCurrentMember(gymClass);
        }
        return gymClass;
    }

    public List<ClassRegistration> getMyActivePendingClasses(Integer memberId) {
        return classRegistrationRepository.findByMemberMemberIdOrderByRegistrationDateDesc(memberId)
                .stream()
                .filter(c -> "ACTIVE".equalsIgnoreCase(c.getStatus())
                        || "PENDING".equalsIgnoreCase(c.getStatus()))
                .toList();
    }

    public Membership getActiveMembership(Integer memberId) {
        return membershipRepository
                .findTopByMemberMemberIdAndStatusOrderByStartDateDesc(memberId, "ACTIVE");
    }

    public Membership getPendingMembership(Integer memberId) {
        return membershipRepository.findAll().stream()
                .filter(m -> m.getMember() != null)
                .filter(m -> m.getMember().getMemberId().equals(memberId))
                .filter(m -> "PENDING".equalsIgnoreCase(m.getStatus()))
                .findFirst()
                .orElse(null);
    }

    public Membership getMembershipByMembershipId(Integer id) {
        return membershipRepository.findById(id).orElse(null);
    }

    public List<Membership> getMembershipHistory(Integer memberId) {
        return membershipRepository.findByMemberMemberIdOrderByCreatedAtDesc(memberId);
    }

    @Transactional
    public int registerMembership(Integer memberId, Integer packageId) {
        if (getActiveMembership(memberId) != null) return -2;
        if (getPendingMembership(memberId) != null) return -3;

        Member member = memberRepository.findById(memberId).orElse(null);
        GymPackage pkg = packageRepository.findById(packageId).orElse(null);

        if (member == null || pkg == null) return -1;

        Membership m = new Membership();
        m.setMember(member);
        m.setGymPackage(pkg);
        m.setStartDate(LocalDate.now());
        m.setEndDate(LocalDate.now().plusMonths(pkg.getDurationMonths()));
        m.setStatus("PENDING");

        Membership saved = membershipRepository.save(m);

        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Đăng ký gói mới",
                member.getFullname() + " vừa đăng ký gói " + pkg.getPackageName(),
                "/receptionist/memberships"
        );

        return saved.getMembershipId();
    }

    @Transactional
    public int renewMembership(Integer memberId, Integer packageId) {
        if (getPendingMembership(memberId) != null) return -3;

        Member member = memberRepository.findById(memberId).orElse(null);
        GymPackage pkg = packageRepository.findById(packageId).orElse(null);

        if (member == null || pkg == null) return -1;

        LocalDate start = LocalDate.now();
        Membership active = getActiveMembership(memberId);
        if (active != null && active.getEndDate() != null && active.getEndDate().isAfter(LocalDate.now())) {
            start = active.getEndDate().plusDays(1);
        }

        Membership m = new Membership();
        m.setMember(member);
        m.setGymPackage(pkg);
        m.setStartDate(start);
        m.setEndDate(start.plusMonths(pkg.getDurationMonths()));
        m.setStatus("PENDING");

        return membershipRepository.save(m).getMembershipId();
    }

    @Transactional
    public int registerClass(Integer memberId, Integer classId) {
        Member member = memberRepository.findById(memberId).orElse(null);
        GymClass gymClass = gymClassRepository.findById(classId).orElse(null);

        if (member == null || gymClass == null) return -1;

        boolean existed = classRegistrationRepository.findByMemberMemberIdOrderByRegistrationDateDesc(memberId)
                .stream()
                .anyMatch(registration ->
                        registration.getGymClass() != null
                                && registration.getGymClass().getClassId() != null
                                && registration.getGymClass().getClassId().equals(classId)
                                && ("PENDING".equalsIgnoreCase(registration.getStatus())
                                || "ACTIVE".equalsIgnoreCase(registration.getStatus()))
                );

        if (existed) return -2;

        int activeCount = classRegistrationRepository.findByGymClass_ClassIdAndStatus(classId, "ACTIVE").size();
        syncClassCurrentMember(gymClass);

        if (activeCount >= gymClass.getMaxMember()) return -3;

        ClassRegistration cr = new ClassRegistration();
        cr.setMember(member);
        cr.setGymClass(gymClass);
        cr.setService(gymClass.getService());
        cr.setRegistrationDate(LocalDate.now());
        cr.setStartDate(null);
        cr.setEndDate(null);
        cr.setStatus("PENDING");
        cr.setNote("Đăng ký từ hội viên, chờ xác nhận thanh toán và duyệt lớp.");

        ClassRegistration saved = classRegistrationRepository.save(cr);

        syncClassCurrentMember(gymClass);
        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Đăng ký lớp mới",
                member.getFullname() + " vừa đăng ký lớp " + gymClass.getClassName(),
                "/receptionist/class-registrations"
        );

        return saved.getRegistrationId();
    }

    public ClassRegistration getClassRegistrationByClassRegistrationId(Integer id) {
        return classRegistrationRepository.findById(id).orElse(null);
    }

    public List<ClassRegistration> getClassRegistrationHistory(Integer memberId) {
        return classRegistrationRepository.findByMemberMemberIdOrderByRegistrationDateDesc(memberId);
    }

    @Transactional
    public boolean createPayment(Integer membershipId, Integer classRegistrationId, BigDecimal amount) {
        Payment p = new Payment();

        if (membershipId != null) {
            Membership m = membershipRepository.findById(membershipId).orElse(null);
            p.setMembership(m);
        }

        if (classRegistrationId != null) {
            ClassRegistration cr = classRegistrationRepository.findById(classRegistrationId).orElse(null);
            p.setClassRegistration(cr);
        }

        p.setAmount(amount);
        p.setStatus("PENDING");
        p.setPaymentMethod("BANK_TRANSFER");
        p.setPaymentDate(LocalDate.now());

        paymentRepository.save(p);
        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Thanh toán mới",
                "Có thanh toán mới từ hội viên",
                "/receptionist/payments"
        );

        return true;
    }

    public Payment getPaymentByMembershipId(Integer id) {
        return paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(id)
                .orElse(null);
    }

    public Payment getPaymentByClassRegistrationId(Integer id) {
        return paymentRepository
                .findTopByClassRegistrationRegistrationIdOrderByCreatedAtDesc(id)
                .orElse(null);
    }

    public List<Payment> getPaymentHistory(Integer memberId) {
        return paymentRepository.findByMemberId(memberId);
    }

    @Transactional
    public boolean uploadPaymentProof(Integer membershipId,
                                      Integer classRegistrationId,
                                      MultipartFile file,
                                      String uploadDir) throws IOException {
        Payment payment = null;

        if (membershipId != null) {
            payment = getPaymentByMembershipId(membershipId);
        }

        if (classRegistrationId != null) {
            payment = getPaymentByClassRegistrationId(classRegistrationId);
        }

        if (payment == null || file == null || file.isEmpty()) return false;

        Path dir = Paths.get(uploadDir, "payments").toAbsolutePath().normalize();
        Files.createDirectories(dir);

        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf('.'));
        }

        String fileName = UUID.randomUUID() + ext;
        Files.copy(file.getInputStream(), dir.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);

        payment.setProofImage("payments/" + fileName);
        paymentRepository.save(payment);

        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Minh chứng thanh toán",
                "Hội viên vừa upload minh chứng thanh toán",
                "/receptionist/payments"
        );
        return true;
    }

    private Comparator<Member> memberNameComparator() {
        return Comparator
                .comparing((Member member) -> extractLastName(member.getFullname()), String.CASE_INSENSITIVE_ORDER)
                .thenComparing(member -> normalizeNameForSort(member.getFullname()), String.CASE_INSENSITIVE_ORDER)
                .thenComparing(Member::getMemberId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private boolean matchKeyword(Member member, String keyword) {
        if (keyword == null) {
            return true;
        }

        String keywordLower = keyword.toLowerCase();
        String fullname = member.getFullname() != null ? member.getFullname().toLowerCase() : "";
        String phone = member.getPhone() != null ? member.getPhone().toLowerCase() : "";
        String email = member.getEmail() != null ? member.getEmail().toLowerCase() : "";

        return fullname.contains(keywordLower)
                || phone.contains(keywordLower)
                || email.contains(keywordLower);
    }

    private String extractLastName(String fullName) {
        String normalized = normalizeNameForSort(fullName);
        if (normalized.isEmpty()) {
            return "";
        }

        String[] parts = normalized.split(" ");
        return parts[parts.length - 1];
    }

    private String normalizeNameForSort(String fullName) {
        if (fullName == null) {
            return "";
        }
        return fullName.trim().replaceAll("\\s+", " ");
    }

    private void normalizeMember(Member member) {
        member.setFullname(trimToNull(member.getFullname()));
        member.setPhone(trimToNull(member.getPhone()));
        member.setEmail(trimToNull(member.getEmail()));
        member.setAddress(trimToNull(member.getAddress()));
        member.setGender(normalizeGender(member.getGender()));
        member.setAvatar(trimToNull(member.getAvatar()));
    }

    private void validateMember(Member member) {
        if (!hasText(member.getFullname())) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }

        if (hasText(member.getPhone()) && !PHONE_PATTERN.matcher(member.getPhone()).matches()) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ");
        }

        if (hasText(member.getEmail()) && !EMAIL_PATTERN.matcher(member.getEmail()).matches()) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }

        if (member.getDob() != null && member.getDob().isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Ngày sinh không hợp lệ");
        }

        if (member.getStatus() == null) {
            member.setStatus(1);
        }

        if (member.getStatus() != 0 && member.getStatus() != 1) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }
    }

    private String validateProfile(Member member) {
        if (member.getFullname() == null || member.getFullname().isBlank()) {
            return "Họ tên không được để trống";
        }

        if (member.getPhone() != null && !member.getPhone().isBlank()
                && !PHONE_PATTERN.matcher(member.getPhone()).matches()) {
            return "Số điện thoại không hợp lệ";
        }

        if (member.getEmail() != null && !member.getEmail().isBlank()
                && !EMAIL_PATTERN.matcher(member.getEmail()).matches()) {
            return "Email không hợp lệ";
        }

        if (member.getDob() != null && member.getDob().isAfter(LocalDate.now())) {
            return "Ngày sinh không hợp lệ";
        }

        return null;
    }

    private void bindUser(Member member, Integer userId, Integer excludeMemberId) {
        if (userId == null) {
            member.setUser(null);
            return;
        }

        if (existsByUserId(userId, excludeMemberId)) {
            throw new IllegalArgumentException("Tài khoản này đã được gán cho hội viên khác");
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new IllegalArgumentException("Không tìm thấy tài khoản được chọn");
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("Không thể liên kết tài khoản đang bị khóa");
        }

        if (!isMemberRoleUser(user)) {
            throw new IllegalArgumentException("Chỉ được liên kết user có role MEMBER");
        }

        member.setUser(user);
    }

    private boolean isMemberRoleUser(User user) {
        return user != null
                && user.getRoleName() != null
                && "MEMBER".equalsIgnoreCase(user.getRoleName().trim());
    }

    private Role resolveMemberRole() {
        return roleRepository.findAll(Sort.by(Sort.Direction.ASC, "roleId"))
                .stream()
                .filter(role -> role.getRoleName() != null && "MEMBER".equalsIgnoreCase(role.getRoleName().trim()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy role MEMBER"));
    }

    private void applyAvatarDefault(Member member) {
        if (!hasText(member.getAvatar())) {
            member.setAvatar(defaultAvatar());
        }
    }

    private String defaultAvatar() {
        return "assets/images/default-avatar.png";
    }

    private String normalizeGender(String gender) {
        String value = trimToNull(gender);
        if (value == null) {
            return null;
        }

        if ("Male".equalsIgnoreCase(value) || "Nam".equalsIgnoreCase(value)) {
            return "Male";
        }
        if ("Female".equalsIgnoreCase(value) || "Nữ".equalsIgnoreCase(value) || "Nu".equalsIgnoreCase(value)) {
            return "Female";
        }
        if ("Other".equalsIgnoreCase(value) || "Khác".equalsIgnoreCase(value) || "Khac".equalsIgnoreCase(value)) {
            return "Other";
        }

        return value;
    }

    private String normalizeUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username không được để trống");
        }
        return username.trim();
    }

    private void validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }

        if (password.trim().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
        }
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    @Transactional
    public boolean cancelMembership(Integer membershipId, Integer memberId) {
        Membership membership = membershipRepository
                .findByMembershipIdAndMemberMemberId(membershipId, memberId)
                .orElse(null);

        if (membership == null) {
            return false;
        }

        if (!"PENDING".equalsIgnoreCase(membership.getStatus())) {
            return false;
        }

        membership.setStatus("CANCELLED");

        Payment payment = paymentRepository
                .findTopByMembershipMembershipIdOrderByCreatedAtDesc(membershipId)
                .orElse(null);

        if (payment != null) {
            payment.setStatus("CANCELLED");
            paymentRepository.save(payment);
        }

        membershipRepository.save(membership);
        return true;
    }
    public String changePassword(Integer userId,
                                 String currentPassword,
                                 String newPassword,
                                 String confirmPassword) {
        if (!newPassword.equals(confirmPassword)) {
            return "Mật khẩu mới và xác nhận không khớp.";
        }
        if (newPassword.length() < 6) {
            return "Mật khẩu mới phải có ít nhất 6 ký tự.";
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return "Không tìm thấy tài khoản.";

        if (!PasswordUtil.verify(currentPassword, user.getPassword())) {
            return "Mật khẩu hiện tại không đúng.";
        }

        user.setPassword(PasswordUtil.hash(newPassword));
        userRepository.save(user);
        return null;
    }
    private void syncClassCurrentMember(GymClass gymClass) {
        if (gymClass == null || gymClass.getClassId() == null) {
            return;
        }

        int activeCount = classRegistrationRepository
                .findByGymClass_ClassIdAndStatus(gymClass.getClassId(), "ACTIVE")
                .size();

        if (gymClass.getCurrentMember() == null || gymClass.getCurrentMember() != activeCount) {
            gymClass.setCurrentMember(activeCount);
            gymClassRepository.save(gymClass);
        }
    }
    public List<Schedule> getSchedulesByClassId(Integer classId) {
        return scheduleRepository.findByGymClass_ClassId(classId);
    }
}