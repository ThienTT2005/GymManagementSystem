package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String listUsers(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String roleName,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<User> userPage = userService.searchUsers(keyword, roleName, status, page, size);

        model.addAttribute("pageTitle", "Quản lý tài khoản");
        model.addAttribute("activePage", "users");
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleName", roleName);
        model.addAttribute("status", status);
        model.addAttribute("userPage", userPage);

        return "admin/users/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        User user = new User();
        user.setStatus(1);

        model.addAttribute("pageTitle", "Thêm tài khoản");
        model.addAttribute("activePage", "users");
        model.addAttribute("user", user);
        model.addAttribute("isEdit", false);

        return "admin/users/form";
    }

    @PostMapping("/create")
    public String createUser(
            @Valid @ModelAttribute("user") User user,
            BindingResult bindingResult,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (userService.existsByUsername(user.getUsername(), null)) {
            bindingResult.rejectValue("username", "error.username", "Username đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("isEdit", false);
            return "admin/users/form";
        }

        userService.createUser(user, avatarFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm tài khoản thành công");
        return "redirect:/admin/users";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        User user = userService.getUserById(id);
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản");
            return "redirect:/admin/users";
        }

        user.setPassword("");

        model.addAttribute("pageTitle", "Cập nhật tài khoản");
        model.addAttribute("activePage", "users");
        model.addAttribute("user", user);
        model.addAttribute("isEdit", true);

        return "admin/users/form";
    }

    @PostMapping("/edit/{id}")
    public String updateUser(
            @PathVariable Integer id,
            @Valid @ModelAttribute("user") User user,
            BindingResult bindingResult,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (userService.getUserById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản");
            return "redirect:/admin/users";
        }

        if (userService.existsByUsername(user.getUsername(), id)) {
            bindingResult.rejectValue("username", "error.username", "Username đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            user.setUserId(id);
            model.addAttribute("pageTitle", "Cập nhật tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("isEdit", true);
            return "admin/users/form";
        }

        userService.updateUser(id, user, avatarFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật tài khoản thành công");
        return "redirect:/admin/users";
    }

    @PostMapping("/delete/{id}")
    public String deleteUser(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = userService.softDeleteUser(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Ngừng kích hoạt tài khoản thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản");
        }

        return "redirect:/admin/users";
    }
}