package com.gym.GymManagementSystem.controller.auth;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
public class AuthController {

    private final AuthService authService;
    private final UserRepository userRepository;

    public AuthController(AuthService authService, UserRepository userRepository) {
        this.authService = authService;
        this.userRepository = userRepository;
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser != null) {
            String roleName = resolveRoleNameFromSessionOrUser(session, loggedInUser);
            String redirectPath = getRedirectByRole(roleName);

            if (!"/login".equals(redirectPath)) {
                return "redirect:" + redirectPath;
            }

            session.invalidate();
        }
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser != null) {
            String roleName = resolveRoleNameFromSessionOrUser(session, loggedInUser);
            String redirectPath = getRedirectByRole(roleName);

            if (!"/login".equals(redirectPath)) {
                return "redirect:" + redirectPath;
            }

            session.invalidate();
        }
        return "auth/register";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ username và password");
            model.addAttribute("username", username);
            return "auth/login";
        }

        User user = authService.login(username.trim(), password);

        if (user == null) {
            model.addAttribute("error", "Sai tài khoản, mật khẩu hoặc tài khoản đã bị khóa");
            model.addAttribute("username", username);
            return "auth/login";
        }

        String roleName = resolveRoleName(user);

        if (roleName == null || roleName.isBlank()) {
            model.addAttribute("error", "Tài khoản chưa được gán quyền hợp lệ");
            model.addAttribute("username", username);
            return "auth/login";
        }

        session.setAttribute("loggedInUser", user);
        session.setAttribute("roleName", roleName);

        return "redirect:" + getRedirectByRole(roleName);
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String confirmPassword,
                           @RequestParam String fullName,
                           @RequestParam String phone,
                           @RequestParam(required = false) String email,
                           @RequestParam(required = false) String address,
                           @RequestParam(required = false) String gender,
                           @RequestParam(required = false)
                           @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dob,
                           Model model) {

        username = username == null ? "" : username.trim();
        fullName = fullName == null ? "" : fullName.trim();
        phone = phone == null ? "" : phone.trim();
        email = email == null ? null : email.trim();
        address = address == null ? null : address.trim();
        gender = gender == null ? null : gender.trim();

        model.addAttribute("username", username);
        model.addAttribute("fullName", fullName);
        model.addAttribute("phone", phone);
        model.addAttribute("email", email);
        model.addAttribute("address", address);
        model.addAttribute("gender", gender);
        model.addAttribute("dob", dob);

        if (username.isBlank() || password == null || password.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()
                || fullName.isBlank() || phone.isBlank()) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc");
            return "auth/register";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu không khớp");
            return "auth/register";
        }

        if (password.trim().length() < 6) {
            model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            return "auth/register";
        }

        if (userRepository.findByUsername(username).isPresent()) {
            model.addAttribute("error", "Tài khoản đã tồn tại");
            return "auth/register";
        }

        try {
            authService.register(username, password, fullName, phone, email, address, gender, dob);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register";
        }

        return "redirect:/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/403")
    public String accessDenied(Model model) {
        model.addAttribute("pageTitle", "403 - Cấm truy cập");
        return "error/403";
    }

    private String resolveRoleName(User user) {
        if (user == null || user.getRole() == null || user.getRole().getRoleName() == null) {
            return null;
        }
        return user.getRole().getRoleName().trim();
    }

    private String resolveRoleNameFromSessionOrUser(HttpSession session, User user) {
        Object sessionRole = session.getAttribute("roleName");
        if (sessionRole instanceof String roleName && !roleName.isBlank()) {
            return roleName.trim();
        }

        String roleName = resolveRoleName(user);
        if (roleName != null && !roleName.isBlank()) {
            session.setAttribute("roleName", roleName);
        }
        return roleName;
    }

    private String getRedirectByRole(String roleName) {
        if (roleName == null || roleName.isBlank()) {
            return "/login";
        }

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