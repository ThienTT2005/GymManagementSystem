package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final NewsService newsService;

    public HomeController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping({"/", "/index"})
    public String showHome(Model model) {
        NewsPageResponseDto memberNews = newsService.getNews("CAU_CHUYEN_HOI_VIEN", 0, 3);
        model.addAttribute("memberNews", memberNews);
        return "pages/index";
    }
}