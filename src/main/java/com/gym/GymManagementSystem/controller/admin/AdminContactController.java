package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.service.ConsultationService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/contacts")
public class AdminContactController {

    private final ConsultationService consultationService;

    public AdminContactController(ConsultationService consultationService) {
        this.consultationService = consultationService;
    }

    @GetMapping
    public String listContacts(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Consultation> contactPage = consultationService.searchContacts(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý tư vấn");
        model.addAttribute("activePage", "contacts");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("contacts", contactPage.getContent());
        model.addAttribute("contactPage", contactPage);

        return "admin/contacts/list";
    }

    @GetMapping("/create")
    public String redirectCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp yêu cầu tư vấn. Dữ liệu phải đến từ Guest/Public form."
        );
        return "redirect:/admin/contacts";
    }

    @PostMapping("/create")
    public String blockCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp yêu cầu tư vấn. Dữ liệu phải đến từ Guest/Public form."
        );
        return "redirect:/admin/contacts";
    }

    @GetMapping("/edit/{id}")
    public String redirectEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp yêu cầu tư vấn. Chỉ cập nhật trạng thái xử lý."
        );
        return "redirect:/admin/contacts";
    }

    @PostMapping("/edit/{id}")
    public String blockEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp yêu cầu tư vấn. Chỉ cập nhật trạng thái xử lý."
        );
        return "redirect:/admin/contacts";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam String status,
                               RedirectAttributes redirectAttributes) {
        try {
            consultationService.updateStatus(id, status);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái tư vấn thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể cập nhật trạng thái tư vấn");
        }
        return "redirect:/admin/contacts";
    }

    @PostMapping("/delete/{id}")
    public String deleteContact(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = consultationService.deleteContact(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật trạng thái liên hệ");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy yêu cầu tư vấn");
        }

        return "redirect:/admin/contacts";
    }
}