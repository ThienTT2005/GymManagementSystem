package com.gym.GymManagementSystem;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class HomeController {

    public RedirectView home() {
        return new RedirectView("/pages/index.jsp");
    }
}
