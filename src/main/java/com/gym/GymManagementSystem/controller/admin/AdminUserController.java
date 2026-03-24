package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.User;
import com.gym.GymManagementSystem.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.UUID;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String listUsers(@RequestParam(value = "keyword", required = false) String keyword,
                            @RequestParam(value = "role", required = false) String role,
                            @RequestParam(value = "status", required = false) String status,
                            @RequestParam(value = "page", defaultValue = "0") int page,
                            @RequestParam(value = "size", defaultValue = "5") int size,
                            Model model) {

        var userPage = userService.searchUsers(keyword, role, status, page, size);

        model.addAttribute("pageTitle", "Quản lý người dùng");
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("size", size);

        return "admin/users/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        User user = new User();
        user.setCreatedDate(LocalDate.now());
        user.setStatus("Hoạt động");
        user.setRole("MEMBER");

        model.addAttribute("pageTitle", "Thêm người dùng");
        model.addAttribute("user", user);
        return "admin/users/form";
    }

    @PostMapping("/save")
    public String saveUser(@ModelAttribute("user") User user,
                           @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                           @RequestParam(value = "existingAvatar", required = false) String existingAvatar) {

        if (user.getCreatedDate() == null) {
            user.setCreatedDate(LocalDate.now());
        }
        if (user.getStatus() == null || user.getStatus().isBlank()) {
            user.setStatus("Hoạt động");
        }
        if (user.getRole() == null || user.getRole().isBlank()) {
            user.setRole("MEMBER");
        }

        if (avatarFile != null && !avatarFile.isEmpty()) {
            try {
                String fileName = UUID.randomUUID() + "_" +
                        StringUtils.cleanPath(avatarFile.getOriginalFilename());

                Path uploadDir = Paths.get("src/main/webapp/uploads/avatars");
                if (!Files.exists(uploadDir)) {
                    Files.createDirectories(uploadDir);
                }

                Path filePath = uploadDir.resolve(fileName);
                avatarFile.transferTo(filePath.toFile());

                user.setAvatar("/uploads/avatars/" + fileName);

            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            user.setAvatar(existingAvatar);
        }

        userService.save(user);
        return "redirect:/admin/users";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("pageTitle", "Sửa người dùng");
        model.addAttribute("user", user);
        return "admin/users/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteById(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Long id) {
        userService.toggleStatus(id);
        return "redirect:/admin/users";
    }
}