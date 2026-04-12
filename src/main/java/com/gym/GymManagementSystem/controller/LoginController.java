package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.User;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.security.LoggedInUser;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Objects;
import java.util.Optional;

@Controller
public class LoginController {

    private final UserRepository userRepository;
    private final MemberRepository memberRepository;
    private final StaffRepository staffRepository;

    public LoginController(UserRepository userRepository,
                           MemberRepository memberRepository,
                           StaffRepository staffRepository) {
        this.userRepository = userRepository;
        this.memberRepository = memberRepository;
        this.staffRepository = staffRepository;
    }

    @PostMapping({ "/login", "/pages/login" })
    public String login(
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "user", required = false) String username,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "pass", required = false) String pass,
            @RequestParam(value = "role", required = false) String role,
            HttpSession session) {

        String loginId = StringUtils.hasText(email) ? email : username;
        String rawPassword = StringUtils.hasText(password) ? password : pass;

        if (!StringUtils.hasText(loginId) || !StringUtils.hasText(rawPassword)) {
            return "redirect:/pages/login.jsp?error=1";
        }

        Optional<User> byUsername = userRepository.findByUsernameFetched(loginId);
        Optional<User> byMemberEmail = memberRepository.findByEmailFetched(loginId).map(m -> m.getUser());
        Optional<User> byStaffEmail = staffRepository.findByEmailFetched(loginId).map(s -> s.getUser());

        User user = byUsername
                .or(() -> byMemberEmail)
                .or(() -> byStaffEmail)
                .orElse(null);

        boolean passwordCorrect = user != null && Objects.equals(user.getPassword(), rawPassword);
        boolean active = user != null && user.isActiveAccount();

        if (!passwordCorrect || !active) {
            return "redirect:/pages/login.jsp?error=1";
        }

        String roleName = user.getRole() != null ? user.getRole() : "MEMBER";
        session.setAttribute("loggedInUser", new LoggedInUser(
                user.getFullName(),
                roleName,
                user.getEmail(),
                user.getPhone(),
                user.getUserId()));

        if ("staff".equalsIgnoreCase(role)) {
            if ("ADMIN".equalsIgnoreCase(roleName) || "STAFF".equalsIgnoreCase(roleName)) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/member/dashboard";
        }

        if ("MEMBER".equalsIgnoreCase(roleName)) {
            return "redirect:/member/dashboard";
        }

        return "redirect:/";
    }

    @GetMapping({ "/logout" })
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/";
    }
}
