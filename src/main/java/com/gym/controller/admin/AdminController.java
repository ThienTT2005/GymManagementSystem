package com.gym.controller.admin;

import com.gym.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {

    @GetMapping("/admin/home")
    public String home(HttpSession session) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        if (!user.getRole().getRoleName().equals("Admin")) {
            return "redirect:/error/403";
        }

        return "admin/home";
    }
}