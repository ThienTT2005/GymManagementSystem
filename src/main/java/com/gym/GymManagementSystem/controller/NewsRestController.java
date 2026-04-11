package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/news")
public class NewsRestController {

    @Autowired
    private NewsService newsService;

    @GetMapping
    public NewsPageResponseDto getNews(
            @RequestParam(defaultValue = "") String category,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "9") int size
    ) {
        return newsService.getNews(category, page, size);
    }
}