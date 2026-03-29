package com.gym.controller.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MemberController {

    @GetMapping("/member/home")
    public String home() {
        System.out.println(">>> HIT MEMBER HOME <<<");
        return "member/home";
    }
}