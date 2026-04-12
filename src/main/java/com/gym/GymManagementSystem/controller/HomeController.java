package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.service.NewsService;
import com.gym.GymManagementSystem.repository.GymServiceRepository;
import com.gym.GymManagementSystem.entity.GymService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    private final NewsService newsService;
    private final GymServiceRepository serviceRepository;

    public HomeController(NewsService newsService, GymServiceRepository serviceRepository) {
        this.newsService = newsService;
        this.serviceRepository = serviceRepository;
    }

    @GetMapping({"/", "/index"})
    public String showHome(Model model) {
        NewsPageResponseDto memberNews = newsService.getNews("CAU_CHUYEN_HOI_VIEN", 0, 3);
        model.addAttribute("memberNews", memberNews);
        
        List<GymService> services = serviceRepository.findByStatus((byte) 1);
        model.addAttribute("services", services);

        return "pages/index";
    }
}