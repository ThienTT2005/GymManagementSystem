package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.gym.GymManagementSystem.model.News;

@Controller
@RequestMapping("/news")
public class NewsController {

    private final NewsService newsService;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping
    public String showNews(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String category,
            Model model
    ) {
        Page<News> newsPage = newsService.searchNews(
                null,
                category,
                1,
                page,
                size
        );
        model.addAttribute("newsPage", newsPage);
        model.addAttribute("newsList", newsPage.getContent());
        model.addAttribute("currentCategory", category);

        return "pages/news";
    }
    @GetMapping("/{id}")
    public String showNewsDetail(@PathVariable Integer id, Model model) {
        News news = newsService.getNewsById(id);

        if (news == null || news.getStatus() == 0) {
            return "redirect:/news";
        }

        model.addAttribute("news", news);
        return "pages/news-detail";
    }
}