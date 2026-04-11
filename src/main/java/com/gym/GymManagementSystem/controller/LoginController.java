package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.User;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.security.LoggedInUser;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Objects;

@Controller
public class LoginController {

    private final UserRepository userRepository;

    public LoginController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @PostMapping({ "/login", "/pages/login" })
    public String login(
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "user", required = false) String username,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "pass", required = false) String pass,
            @RequestParam(value = "role", required = false) String role,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        String loginId = StringUtils.hasText(email) ? email : username;
        String rawPassword = StringUtils.hasText(password) ? password : pass;

        if (!StringUtils.hasText(loginId) || !StringUtils.hasText(rawPassword)) {
            return "redirect:/pages/login.jsp?error=1";
        }

        User user = userRepository.findByUsername(loginId)
                .orElseGet(() -> userRepository.findByEmail(loginId).orElse(null));

        boolean passwordCorrect = user != null && Objects.equals(user.getPassword(), rawPassword);
        boolean active = user == null
                || user.getStatus() == null
                || "hoạt động".equalsIgnoreCase(user.getStatus())
                || "active".equalsIgnoreCase(user.getStatus());

        if (!passwordCorrect || !active) {
            return "redirect:/pages/login.jsp?error=1";
        }

        boolean isAdmin = user.getUsername() != null && user.getUsername().equalsIgnoreCase("admin")
                || user.getRole() != null && user.getRole().equalsIgnoreCase("Admin");

        String roleName = isAdmin ? "Admin" : (user.getRole() != null ? user.getRole() : "");
        session.setAttribute("loggedInUser", new LoggedInUser(user.getFullName(), roleName));

        if (isAdmin) {
            return "redirect:/admin/dashboard";
        }

        // Login không phải admin: quay về trang quảng cáo
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
