package com.gym.GymManagementSystem.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class NewsPageController {

    @GetMapping("/news")
    public String showNewsPage() {
        return "pages/News";
    }
}