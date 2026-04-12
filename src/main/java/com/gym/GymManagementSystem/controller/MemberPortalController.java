package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.security.LoggedInUser;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member")
public class MemberPortalController {

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        LoggedInUser user = session != null ? (LoggedInUser) session.getAttribute("loggedInUser") : null;
        if (user == null) {
            return "redirect:/pages/login.jsp";
        }
        String role = user.getRoleName() != null ? user.getRoleName() : "";
        if (!"MEMBER".equalsIgnoreCase(role)) {
            return "redirect:/";
        }
        return "member/dashboard";
    }
}
