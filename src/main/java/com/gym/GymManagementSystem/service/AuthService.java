package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.util.PasswordUtil;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.regex.Pattern;

@Service
public class AuthService {

    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\-\\s]{9,15}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final MemberRepository memberRepository;
    private final NotificationService notificationService;

    public AuthService(UserRepository userRepository,
                       RoleRepository roleRepository,
                       MemberRepository memberRepository,
                       NotificationService notificationService) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.memberRepository = memberRepository;
        this.notificationService = notificationService;
    }

    public User login(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            return null;
        }

        User user = userRepository.findByUsername(username.trim()).orElse(null);
        if (user == null) {
            return null;
        }

        if (user.getStatus() == null || user.getStatus() != 1) {
            return null;
        }

        if (!PasswordUtil.verify(password, user.getPassword())) {
            return null;
        }

        ensureMemberProfileIfNeeded(user);

        return user;
    }

    public boolean existsByUsername(String username) {
        if (username == null || username.isBlank()) {
            return false;
        }
        return userRepository.existsByUsername(username.trim());
    }

    public void register(String username,
                         String password,
                         String fullName,
                         String phone,
                         String email,
                         String address,
                         String gender,
                         LocalDate dob) {

        if (username == null || username.isBlank()
                || password == null || password.isBlank()
                || fullName == null || fullName.isBlank()
                || phone == null || phone.isBlank()) {
            throw new IllegalArgumentException("Thông tin đăng ký không hợp lệ");
        }

        String normalizedUsername = username.trim();
        String normalizedFullName = fullName.trim();
        String normalizedPhone = phone.trim();
        String normalizedEmail = trimToNull(email);
        String normalizedAddress = trimToNull(address);
        String normalizedGender = normalizeGender(gender);

        if (userRepository.existsByUsername(normalizedUsername)) {
            throw new IllegalArgumentException("Tài khoản đã tồn tại");
        }

        if (password.trim().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
        }

        if (!PHONE_PATTERN.matcher(normalizedPhone).matches()) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ");
        }

        if (normalizedEmail != null && !EMAIL_PATTERN.matcher(normalizedEmail).matches()) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }

        if (dob != null && dob.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Ngày sinh không hợp lệ");
        }

        Role memberRole = roleRepository.findById(4)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy role MEMBER"));

        User user = new User();
        user.setUsername(normalizedUsername);
        user.setPassword(PasswordUtil.hash(password));
        user.setStatus(1);
        user.setRole(memberRole);

        User savedUser = userRepository.save(user);

        Member member = new Member();
        member.setFullname(normalizedFullName);
        member.setPhone(normalizedPhone);
        member.setEmail(normalizedEmail);
        member.setAddress(normalizedAddress);
        member.setGender(normalizedGender);
        member.setDob(dob);
        member.setStatus(1);
        member.setAvatar("assets/images/default-avatar.png");
        member.setUser(savedUser);

        // ✅ Lưu member trước
        memberRepository.save(member);

        // 🔥 NOTIFICATION CHUẨN NGHIỆP VỤ

        // Receptionist + Admin
        notificationService.createNotificationForRoles(
                List.of("RECEPTIONIST", "ADMIN"),
                "Hội viên mới",
                normalizedFullName + " vừa đăng ký tài khoản mới",
                "/admin/members"
        );

        // Chính member
        notificationService.createNotification(
                savedUser.getUserId(),
                "Đăng ký thành công",
                "Tài khoản của bạn đã được tạo thành công",
                "/member/dashboard"
        );
    }

    private void ensureMemberProfileIfNeeded(User user) {
        if (user == null || user.getRole() == null || user.getRole().getRoleName() == null) {
            return;
        }

        if (!"MEMBER".equalsIgnoreCase(user.getRole().getRoleName().trim())) {
            return;
        }

        boolean exists = memberRepository.findByUserUserId(user.getUserId()).isPresent();
        if (exists) {
            return;
        }

        Member member = new Member();
        member.setFullname(user.getUsername());
        member.setPhone("0000000000");
        member.setEmail(null);
        member.setAddress(null);
        member.setGender(null);
        member.setDob(null);
        member.setStatus(1);
        member.setAvatar("assets/images/default-avatar.png");
        member.setUser(user);

        memberRepository.save(member);
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeGender(String gender) {
        String value = trimToNull(gender);
        if (value == null) return null;

        if ("Male".equalsIgnoreCase(value) || "Nam".equalsIgnoreCase(value)) return "Male";
        if ("Female".equalsIgnoreCase(value) || "Nữ".equalsIgnoreCase(value) || "Nu".equalsIgnoreCase(value)) return "Female";
        if ("Other".equalsIgnoreCase(value) || "Khác".equalsIgnoreCase(value) || "Khac".equalsIgnoreCase(value)) return "Other";

        return value;
    }
}