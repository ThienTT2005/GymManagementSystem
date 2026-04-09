package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
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
    public String showCreateForm(Model model) {
        ClassRegistration registration = new ClassRegistration();
        registration.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm đăng ký lớp");
        model.addAttribute("activePage", "class-registrations");
        model.addAttribute("registration", registration);
        model.addAttribute("members", classRegistrationService.getAllMembers());
        model.addAttribute("classes", classRegistrationService.getAllClasses());
        model.addAttribute("services", classRegistrationService.getAllServices());
        model.addAttribute("isEdit", false);

        return "admin/class-registrations/form";
    }

    @PostMapping("/create")
    public String create(
            @Valid @ModelAttribute("registration") ClassRegistration registration,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer memberId,
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer serviceId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }
        if (classId == null) {
            bindingResult.reject("classId", "Vui lòng chọn lớp học");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", false);
            return "admin/class-registrations/form";
        }

        try {
            classRegistrationService.createRegistration(registration, memberId, classId, serviceId);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký lớp thành công");
            return "redirect:/admin/class-registrations";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("pageTitle", "Thêm đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", false);
            return "admin/class-registrations/form";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        ClassRegistration registration = classRegistrationService.getRegistrationById(id);
        if (registration == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký lớp");
            return "redirect:/admin/class-registrations";
        }

        model.addAttribute("pageTitle", "Cập nhật đăng ký lớp");
        model.addAttribute("activePage", "class-registrations");
        model.addAttribute("registration", registration);
        model.addAttribute("members", classRegistrationService.getAllMembers());
        model.addAttribute("classes", classRegistrationService.getAllClasses());
        model.addAttribute("services", classRegistrationService.getAllServices());
        model.addAttribute("isEdit", true);

        return "admin/class-registrations/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Integer id,
            @Valid @ModelAttribute("registration") ClassRegistration registration,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer memberId,
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer serviceId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }
        if (classId == null) {
            bindingResult.reject("classId", "Vui lòng chọn lớp học");
        }

        if (bindingResult.hasErrors()) {
            registration.setRegistrationId(id);
            model.addAttribute("pageTitle", "Cập nhật đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", true);
            return "admin/class-registrations/form";
        }

        try {
            ClassRegistration updated = classRegistrationService.updateRegistration(id, registration, memberId, classId, serviceId);
            if (updated == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký lớp");
                return "redirect:/admin/class-registrations";
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký lớp thành công");
            return "redirect:/admin/class-registrations";
        } catch (IllegalArgumentException ex) {
            registration.setRegistrationId(id);
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("pageTitle", "Cập nhật đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", true);
            return "admin/class-registrations/form";
        }
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        classRegistrationService.approve(id);
        redirectAttributes.addFlashAttribute("successMessage", "Duyệt đăng ký lớp thành công");
        return "redirect:/admin/class-registrations";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        classRegistrationService.reject(id);
        redirectAttributes.addFlashAttribute("successMessage", "Từ chối đăng ký lớp thành công");
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