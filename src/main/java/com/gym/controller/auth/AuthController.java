package com.gym.controller.auth;

import com.gym.model.User;
import com.gym.service.AuthService;
import com.gym.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepo;

    // ====== VIEW ======
    @GetMapping("/login")
    public String loginPage() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    // ====== LOGIN ======
    @PostMapping("/login")
    public String login(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model
    ) {

        // validate rỗng
        if (username.isEmpty() || password.isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ");
            return "auth/login";
        }

        User user = authService.login(username, password);

        // sai tài khoản
        if (user == null) {
            model.addAttribute("error", "Sai tài khoản hoặc mật khẩu");
            return "auth/login";
        }

        // lưu session
        session.setAttribute("user", user);

        // phân quyền
        String role = user.getRole().getRoleName();

        if (role.equalsIgnoreCase("Admin")) {
            return "redirect:/admin/home";
        }

        if (role.equalsIgnoreCase("Member")) {
            return "redirect:/member/home";
        }

        return "redirect:/login";
    }

    // ====== REGISTER ======
    @PostMapping("/register")
    public String register(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String fullName,
            Model model
    ) {

        if (username.isEmpty() || password.isEmpty() || confirmPassword.isEmpty() || fullName.isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ");
            return "auth/register";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu không khớp");
            return "auth/register";
        }

        if (userRepo.findByUsername(username) != null) {
            model.addAttribute("error", "Tài khoản đã tồn tại");
            return "auth/register";
        }

        authService.register(username, password, fullName);

        return "redirect:/login";
    }

    // ====== LOGOUT ======
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
