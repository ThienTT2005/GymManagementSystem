package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/class-registrations")
public class AdminClassRegistrationController {

    private final ClassRegistrationService classRegistrationService;

    public AdminClassRegistrationController(ClassRegistrationService classRegistrationService) {
        this.classRegistrationService = classRegistrationService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer classId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<ClassRegistration> registrationPage =
                classRegistrationService.searchRegistrations(keyword, status, classId, page, size);

        model.addAttribute("pageTitle", "Quản lý đăng ký lớp");
        model.addAttribute("activePage", "class-registrations");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("classId", classId);
        model.addAttribute("registrationPage", registrationPage);
        model.addAttribute("classes", classRegistrationService.getAllClasses());

        return "admin/class-registrations/list";
    }

    @GetMapping("/create")
    public String redirectCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký lớp. Vui lòng tạo từ luồng Member hoặc Receptionist."
        );
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/create")
    public String blockCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký lớp. Vui lòng tạo từ luồng Member hoặc Receptionist."
        );
        return "redirect:/admin/class-registrations";
    }

    @GetMapping("/edit/{id}")
    public String redirectEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký lớp. Chỉ được cập nhật trạng thái nghiệp vụ."
        );
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/edit/{id}")
    public String blockEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký lớp. Chỉ được cập nhật trạng thái nghiệp vụ."
        );
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            classRegistrationService.approve(id);
            redirectAttributes.addFlashAttribute("successMessage", "Duyệt đăng ký lớp thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể duyệt đăng ký lớp");
        }
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            classRegistrationService.reject(id);
            redirectAttributes.addFlashAttribute("successMessage", "Từ chối đăng ký lớp thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể từ chối đăng ký lớp");
        }
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = classRegistrationService.cancelRegistration(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký lớp thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký lớp");
        }

        return "redirect:/admin/class-registrations";
    }
}