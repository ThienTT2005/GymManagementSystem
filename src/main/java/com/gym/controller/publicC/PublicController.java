package com.gym.controller.publicC;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PublicController {

    @GetMapping("/")
    public String home() {
        return "public/home";
    }

    @GetMapping("/home")
    public String homePage() {
        return "public/home";
    }
}