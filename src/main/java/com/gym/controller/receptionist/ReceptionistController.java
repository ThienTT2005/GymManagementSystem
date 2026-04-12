package com.gym.controller.receptionist;

import com.gym.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReceptionistController {

    @GetMapping("/receptionist/home")
    public String home(HttpSession session) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        if (!user.getRole().getRoleName().equals("RECEPTIONIST")) {
            return "redirect:/error/403";
        }

        return "receptionist/home";
    }
}