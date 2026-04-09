package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.service.ConsultationService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/contacts")
public class AdminConsultationController {

    private final ConsultationService consultationService;

    public AdminConsultationController(ConsultationService consultationService) {
        this.consultationService = consultationService;
    }

    @GetMapping
    public String listConsultations(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Consultation> consultationPage = consultationService.searchConsultations(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý đăng ký tư vấn");
        model.addAttribute("activePage", "contacts");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("consultationPage", consultationPage);

        return "admin/contacts/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Consultation consultation = new Consultation();
        consultation.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm đăng ký tư vấn");
        model.addAttribute("activePage", "contacts");
        model.addAttribute("consultation", consultation);
        model.addAttribute("isEdit", false);

        return "admin/contacts/form";
    }

    @PostMapping("/create")
    public String createConsultation(
            @Valid @ModelAttribute("consultation") Consultation consultation,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký tư vấn");
            model.addAttribute("activePage", "contacts");
            model.addAttribute("isEdit", false);
            return "admin/contacts/form";
        }

        consultationService.createConsultation(consultation);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký tư vấn thành công");
        return "redirect:/admin/contacts";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Consultation consultation = consultationService.getConsultationById(id);
        if (consultation == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tư vấn");
            return "redirect:/admin/contacts";
        }

        model.addAttribute("pageTitle", "Cập nhật đăng ký tư vấn");
        model.addAttribute("activePage", "contacts");
        model.addAttribute("consultation", consultation);
        model.addAttribute("isEdit", true);

        return "admin/contacts/form";
    }

    @PostMapping("/edit/{id}")
    public String updateConsultation(
            @PathVariable Integer id,
            @Valid @ModelAttribute("consultation") Consultation consultation,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (consultationService.getConsultationById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tư vấn");
            return "redirect:/admin/contacts";
        }

        if (bindingResult.hasErrors()) {
            consultation.setConsultationId(id);
            model.addAttribute("pageTitle", "Cập nhật đăng ký tư vấn");
            model.addAttribute("activePage", "contacts");
            model.addAttribute("isEdit", true);
            return "admin/contacts/form";
        }

        consultationService.updateConsultation(id, consultation);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký tư vấn thành công");
        return "redirect:/admin/contacts";
    }

    @PostMapping("/delete/{id}")
    public String deleteConsultation(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = consultationService.cancelConsultation(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký tư vấn thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tư vấn");
        }

        return "redirect:/admin/contacts";
    }
}