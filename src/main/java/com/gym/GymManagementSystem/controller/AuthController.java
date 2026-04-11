package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.User;
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

    @GetMapping("/")
    public String showIndex() {
        return "redirect:/pages/index.jsp";
    }
}