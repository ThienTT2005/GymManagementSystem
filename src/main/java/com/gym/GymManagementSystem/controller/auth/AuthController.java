package com.gym.GymManagementSystem.controller.auth;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser != null) {
            String roleName = (String) session.getAttribute("roleName");
            return "redirect:" + getRedirectByRole(roleName);
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            model.addAttribute("errorMessage", "Vui lòng nhập đầy đủ username và password");
            model.addAttribute("username", username);
            return "auth/login";
        }

        User user = authService.login(username, password);

        if (user == null) {
            model.addAttribute("errorMessage", "Sai tài khoản, mật khẩu hoặc tài khoản đã bị khóa");
            model.addAttribute("username", username);
            return "auth/login";
        }

        String roleName = resolveRoleName(user);

        session.setAttribute("loggedInUser", user);
        session.setAttribute("roleName", roleName);

        return "redirect:" + getRedirectByRole(roleName);
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/403")
    public String accessDenied(Model model) {
        model.addAttribute("pageTitle", "403 - Cấm truy cập");
        return "error/403";
    }

    private String resolveRoleName(User user) {
        if (user == null) {
            return null;
        }

        try {
            return user.getRoleName();
        } catch (Exception e) {
            return null;
        }
    }

    private String getRedirectByRole(String roleName) {
        if ("ADMIN".equalsIgnoreCase(roleName)) {
            return "/admin/dashboard";
        }
        if ("RECEPTIONIST".equalsIgnoreCase(roleName)) {
            return "/receptionist/dashboard";
        }
        if ("TRAINER".equalsIgnoreCase(roleName)) {
            return "/trainer/dashboard";
        }
        if ("MEMBER".equalsIgnoreCase(roleName)) {
            return "/member/dashboard";
        }

        return "/login";
    }
}