package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.News;
import com.gym.GymManagementSystem.service.NewsService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/news")
public class AdminNewsController {

    private final NewsService newsService;

    public AdminNewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping
    public String listNews(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<News> newsPage = newsService.searchNews(keyword, type, status, page, size);

        model.addAttribute("pageTitle", "Quản lý tin tức");
        model.addAttribute("activePage", "news");
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);
        model.addAttribute("status", status);
        model.addAttribute("newsPage", newsPage);

        return "admin/news/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        News news = new News();
        news.setStatus(1);

        model.addAttribute("pageTitle", "Thêm bài viết");
        model.addAttribute("activePage", "news");
        model.addAttribute("news", news);
        model.addAttribute("isEdit", false);

        return "admin/news/form";
    }

    @PostMapping("/create")
    public String createNews(
            @Valid @ModelAttribute("news") News news,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm bài viết");
            model.addAttribute("activePage", "news");
            model.addAttribute("isEdit", false);
            return "admin/news/form";
        }

        newsService.createNews(news, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm bài viết thành công");
        return "redirect:/admin/news";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        News news = newsService.getNewsById(id);
        if (news == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy bài viết");
            return "redirect:/admin/news";
        }

        model.addAttribute("pageTitle", "Cập nhật bài viết");
        model.addAttribute("activePage", "news");
        model.addAttribute("news", news);
        model.addAttribute("isEdit", true);

        return "admin/news/form";
    }

    @PostMapping("/edit/{id}")
    public String updateNews(
            @PathVariable Integer id,
            @Valid @ModelAttribute("news") News news,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (newsService.getNewsById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy bài viết");
            return "redirect:/admin/news";
        }

        if (bindingResult.hasErrors()) {
            news.setPostId(id);
            model.addAttribute("pageTitle", "Cập nhật bài viết");
            model.addAttribute("activePage", "news");
            model.addAttribute("isEdit", true);
            return "admin/news/form";
        }

        newsService.updateNews(id, news, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật bài viết thành công");
        return "redirect:/admin/news";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        News news = newsService.getNewsById(id);

        if (news == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy bài viết");
            return "redirect:/admin/news";
        }

        int newStatus = (news.getStatus() != null && news.getStatus() == 1) ? 0 : 1;
        newsService.updateStatus(id, newStatus);

        redirectAttributes.addFlashAttribute(
                "successMessage",
                newStatus == 1 ? "Hiển thị bài viết thành công" : "Ẩn bài viết thành công"
        );

        return "redirect:/admin/news";
    }
}