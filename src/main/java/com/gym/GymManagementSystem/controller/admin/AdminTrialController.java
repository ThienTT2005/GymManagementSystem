package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/trials")
public class AdminTrialController {

    private final TrialRegistrationService trialRegistrationService;

    public AdminTrialController(TrialRegistrationService trialRegistrationService) {
        this.trialRegistrationService = trialRegistrationService;
    }

    @GetMapping
    public String listTrials(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String preferredDate,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<TrialRegistration> trialPage = trialRegistrationService.searchTrials(
                keyword, status, preferredDate, page, size
        );

        model.addAttribute("pageTitle", "Quản lý đăng ký tập thử");
        model.addAttribute("activePage", "trials");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("preferredDate", preferredDate);
        model.addAttribute("trials", trialPage.getContent());
        model.addAttribute("trialPage", trialPage);

        return "admin/trials/list";
    }

    @GetMapping("/create")
    public String redirectCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký tập thử. Dữ liệu phải đến từ Guest/Public form."
        );
        return "redirect:/admin/trials";
    }

    @PostMapping("/create")
    public String blockCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký tập thử. Dữ liệu phải đến từ Guest/Public form."
        );
        return "redirect:/admin/trials";
    }

    @GetMapping("/edit/{id}")
    public String redirectEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký tập thử. Chỉ cập nhật trạng thái xử lý."
        );
        return "redirect:/admin/trials";
    }

    @PostMapping("/edit/{id}")
    public String blockEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký tập thử. Chỉ cập nhật trạng thái xử lý."
        );
        return "redirect:/admin/trials";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam String status,
                               RedirectAttributes redirectAttributes) {
        try {
            trialRegistrationService.updateStatus(id, status);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái tập thử thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể cập nhật trạng thái tập thử");
        }
        return "redirect:/admin/trials";
    }

    @PostMapping("/delete/{id}")
    public String deleteTrial(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = trialRegistrationService.deleteTrial(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký tập thử thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tập thử");
        }

        return "redirect:/admin/trials";
    }
}