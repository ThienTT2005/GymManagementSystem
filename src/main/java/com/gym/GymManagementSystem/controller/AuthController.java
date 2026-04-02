package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam("user") String u,
            @RequestParam("pass") String p,
            HttpSession session,
            Model model) {

        User user = userRepository.findByUsernameAndPassword(u, p);

        if (user == null) {
            model.addAttribute("error", "Tai khoan hoac mat khau khong dung!");
            return "login";
        } else {
            session.setAttribute("account", user);
            if (user.getRoleId() == 1) {
                return "redirect:/admin-page";
            } else {
                return "redirect:/member-page";
            }
        }
    }

    @PostMapping("/register")
    public String handleRegister(@RequestParam String user,
            @RequestParam String pass,
            @RequestParam String name,
            @RequestParam String email,
            Model model) {

        if (userRepository.existsByUsername(user)) {
            model.addAttribute("error", "Tai khoan da ton tai!");
            return "login";
        } else {
            User newUser = new User(user, pass, name, email, 2);
            userRepository.save(newUser);
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/admin-page")
    public String adminPage() {
        return "admin";
    }

    @GetMapping("/member-page")
    public String memberPage() {
        return "member";
    }

    @GetMapping("/")
    public String showIndex() {
        return "home";
    }

}