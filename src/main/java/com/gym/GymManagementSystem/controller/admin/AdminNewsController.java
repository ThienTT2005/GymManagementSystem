package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.News;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;

@Controller
@RequestMapping("/admin/news")
public class AdminNewsController {

    private final NewsService newsService;

    public AdminNewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping
    public String listNews(@RequestParam(value = "keyword", required = false) String keyword,
                           @RequestParam(value = "page", defaultValue = "0") int page,
                           @RequestParam(value = "size", defaultValue = "5") int size,
                           Model model) {

        var newsPage = newsService.searchNews(keyword, page, size);

        model.addAttribute("pageTitle", "Quản lý tin tức");
        model.addAttribute("newsList", newsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", newsPage.getTotalPages());
        model.addAttribute("size", size);

        return "admin/news/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        News news = new News();
        news.setCreatedDate(LocalDate.now());

        model.addAttribute("pageTitle", "Thêm tin tức");
        model.addAttribute("news", news);
        return "admin/news/form";
    }

    @PostMapping("/save")
    public String saveNews(@ModelAttribute("news") News news,
                           @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                           @RequestParam(value = "existingImage", required = false) String existingImage) {

        if (news.getCreatedDate() == null) {
            news.setCreatedDate(LocalDate.now());
        }

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String originalFileName = StringUtils.cleanPath(imageFile.getOriginalFilename());
                String fileName = UUID.randomUUID() + "_" + originalFileName;

                String projectDir = System.getProperty("user.dir");
                Path uploadDir = Paths.get(projectDir, "src", "main", "webapp", "assets", "images", "news");

                if (!Files.exists(uploadDir)) {
                    Files.createDirectories(uploadDir);
                }

                Path filePath = uploadDir.resolve(fileName);
                Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                news.setImage("/assets/images/news/" + fileName);
            } else {
                news.setImage(existingImage);
            }

            newsService.save(news);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return "redirect:/admin/news";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        News news = newsService.findById(id);
        model.addAttribute("pageTitle", "Sửa tin tức");
        model.addAttribute("news", news);
        return "admin/news/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteNews(@PathVariable Long id) {
        newsService.deleteById(id);
        return "redirect:/admin/news";
    }
}