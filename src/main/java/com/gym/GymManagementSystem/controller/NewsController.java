package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.gym.GymManagementSystem.entity.News;

@Controller
@RequestMapping("/news")
public class NewsController {

    private final NewsService newsService;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping
    public String showNews(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String category,
            Model model) {

        NewsPageResponseDto newsPage = newsService.getNews(category, page, size);
        model.addAttribute("newsPage", newsPage);
        model.addAttribute("currentCategory", category);

        return "forward:/pages/news.jsp";
    }
    @GetMapping("/{id}")
    public String showNewsDetail(@PathVariable Long id, Model model) {
        News news = newsService.findById(id).orElse(null);

        if (news == null) {
            return "redirect:/news";
        }

        model.addAttribute("news", news);
        return "forward:/pages/news-detail.jsp";
    }


}