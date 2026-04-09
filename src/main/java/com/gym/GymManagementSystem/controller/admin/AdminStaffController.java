package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.service.StaffService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/staff")
public class AdminStaffController {

    private final StaffService staffService;

    public AdminStaffController(StaffService staffService) {
        this.staffService = staffService;
    }

    @GetMapping
    public String listStaffs(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Staff> staffPage = staffService.searchStaffs(keyword, position, status, page, size);

        model.addAttribute("pageTitle", "Quản lý nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("keyword", keyword);
        model.addAttribute("position", position);
        model.addAttribute("status", status);
        model.addAttribute("staffPage", staffPage);

        return "admin/staff/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Staff staff = new Staff();
        staff.setStatus(1);

        model.addAttribute("pageTitle", "Thêm nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("staff", staff);
        model.addAttribute("users", staffService.getAssignableUsers());
        model.addAttribute("isEdit", false);

        return "admin/staff/form";
    }

    @PostMapping("/create")
    public String createStaff(
            @Valid @ModelAttribute("staff") Staff staff,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer userId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (userId != null && staffService.existsByUserId(userId, null)) {
            bindingResult.reject("userId", "Tài khoản này đã được gán cho nhân viên khác");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm nhân viên");
            model.addAttribute("activePage", "staff");
            model.addAttribute("users", staffService.getAssignableUsers());
            model.addAttribute("isEdit", false);
            return "admin/staff/form";
        }

        staffService.createStaff(staff, userId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm nhân viên thành công");
        return "redirect:/admin/staff";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Staff staff = staffService.getStaffById(id);
        if (staff == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        model.addAttribute("pageTitle", "Cập nhật nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("staff", staff);
        model.addAttribute("users", staffService.getAssignableUsers());
        model.addAttribute("isEdit", true);

        return "admin/staff/form";
    }

    @PostMapping("/edit/{id}")
    public String updateStaff(
            @PathVariable Integer id,
            @Valid @ModelAttribute("staff") Staff staff,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer userId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (staffService.getStaffById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        if (userId != null && staffService.existsByUserId(userId, id)) {
            bindingResult.reject("userId", "Tài khoản này đã được gán cho nhân viên khác");
        }

        if (bindingResult.hasErrors()) {
            staff.setStaffId(id);
            model.addAttribute("pageTitle", "Cập nhật nhân viên");
            model.addAttribute("activePage", "staff");
            model.addAttribute("users", staffService.getAssignableUsers());
            model.addAttribute("isEdit", true);
            return "admin/staff/form";
        }

        staffService.updateStaff(id, staff, userId);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật nhân viên thành công");
        return "redirect:/admin/staff";
    }

    @PostMapping("/delete/{id}")
    public String deleteStaff(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = staffService.softDeleteStaff(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Ngừng nhân viên thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
        }

        return "redirect:/admin/staff";
    }
}