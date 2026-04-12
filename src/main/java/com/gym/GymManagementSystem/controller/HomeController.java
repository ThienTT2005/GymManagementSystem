package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.News;
import com.gym.GymManagementSystem.service.NewsService;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import com.gym.GymManagementSystem.model.ServiceGym;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    private final NewsService newsService;
    private final ServiceRepository serviceRepository;

    public HomeController(NewsService newsService, ServiceRepository serviceRepository) {
        this.newsService = newsService;
        this.serviceRepository = serviceRepository;
    }

    @GetMapping({"/", "/index"})
    public String showHome(Model model) {
        Page<News> newsPage = newsService.searchNews(
                null,
                "CAU_CHUYEN_HOI_VIEN",
                1,
                1,
                3
        );

        model.addAttribute("memberNews", newsPage.getContent());

        List<ServiceGym> services = serviceRepository.findByStatus( 1);
        model.addAttribute("services", services);

        return "pages/index";
    }
}