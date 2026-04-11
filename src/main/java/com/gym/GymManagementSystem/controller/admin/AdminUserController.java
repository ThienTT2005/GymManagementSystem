package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
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
            @RequestParam(required = false) Integer roleId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<User> userPage = userService.searchUsers(keyword, roleId, status, page, size);

        model.addAttribute("pageTitle", "Quản lý tài khoản");
        model.addAttribute("activePage", "users");
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleId", roleId);
        model.addAttribute("status", status);
        model.addAttribute("roles", userService.getAllRoles());
        model.addAttribute("userPage", userPage);
        model.addAttribute("users", userPage.getContent());

        return "admin/users/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        User user = new User();
        user.setStatus(1);

        model.addAttribute("pageTitle", "Thêm tài khoản");
        model.addAttribute("activePage", "users");
        model.addAttribute("user", user);
        model.addAttribute("roles", userService.getAllRoles());
        model.addAttribute("isEdit", false);

        return "admin/users/form";
    }

    @PostMapping("/create")
    public String createUser(
            @Valid @ModelAttribute("user") User user,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (userService.existsByUsername(user.getUsername(), null)) {
            bindingResult.rejectValue("username", "error.username", "Username đã tồn tại");
        }

        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            bindingResult.rejectValue("password", "error.password", "Mật khẩu không được để trống");
        }

        if (!userService.isValidRoleId(user.getRoleId())) {
            bindingResult.rejectValue("roleId", "error.roleId", "Vai trò không hợp lệ");
        }

        if (user.getStatus() == null || (user.getStatus() != 0 && user.getStatus() != 1)) {
            bindingResult.rejectValue("status", "error.status", "Trạng thái không hợp lệ");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("roles", userService.getAllRoles());
            model.addAttribute("isEdit", false);
            return "admin/users/form";
        }

        try {
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm tài khoản thành công");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Thêm tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("roles", userService.getAllRoles());
            model.addAttribute("isEdit", false);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/users/form";
        }
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
        model.addAttribute("roles", userService.getAllRoles());
        model.addAttribute("isEdit", true);

        return "admin/users/form";
    }

    @PostMapping("/edit/{id}")
    public String updateUser(
            @PathVariable Integer id,
            @Valid @ModelAttribute("user") User user,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        User existing = userService.getUserById(id);
        if (existing == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản");
            return "redirect:/admin/users";
        }

        if (userService.existsByUsername(user.getUsername(), id)) {
            bindingResult.rejectValue("username", "error.username", "Username đã tồn tại");
        }

        if (!userService.isValidRoleId(user.getRoleId())) {
            bindingResult.rejectValue("roleId", "error.roleId", "Vai trò không hợp lệ");
        }

        if (user.getStatus() == null || (user.getStatus() != 0 && user.getStatus() != 1)) {
            bindingResult.rejectValue("status", "error.status", "Trạng thái không hợp lệ");
        }

        if (bindingResult.hasErrors()) {
            user.setUserId(id);
            model.addAttribute("pageTitle", "Cập nhật tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("roles", userService.getAllRoles());
            model.addAttribute("isEdit", true);
            return "admin/users/form";
        }

        try {
            userService.updateUser(id, user);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật tài khoản thành công");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException e) {
            user.setUserId(id);
            model.addAttribute("pageTitle", "Cập nhật tài khoản");
            model.addAttribute("activePage", "users");
            model.addAttribute("roles", userService.getAllRoles());
            model.addAttribute("isEdit", true);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/users/form";
        }
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

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id,
                               RedirectAttributes redirectAttributes) {

        User user = userService.getUserById(id);

        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy tài khoản");
            return "redirect:/admin/users";
        }

        int newStatus = (user.getStatus() != null && user.getStatus() == 1) ? 0 : 1;

        userService.updateStatus(id, newStatus);

        redirectAttributes.addFlashAttribute(
                "successMessage",
                newStatus == 1
                        ? "Mở khóa tài khoản thành công"
                        : "Khóa tài khoản thành công"
        );

        return "redirect:/admin/users";
    }
}