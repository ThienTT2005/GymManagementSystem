package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.util.PasswordUtil;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@Service
public class MemberService {

    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\-\\s]{9,15}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private final MemberRepository memberRepository;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public MemberService(MemberRepository memberRepository,
                         UserRepository userRepository,
                         RoleRepository roleRepository) {
        this.memberRepository = memberRepository;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
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

    public Member createMember(Member member) {
        return createMember(member, null);
    }

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

    public Member updateMember(Member member) {
        if (member == null || member.getMemberId() == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }
        return updateMember(member.getMemberId(), member, null);
    }

    public boolean deleteMember(Integer id) {
        return softDeleteMember(id);
    }

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
}