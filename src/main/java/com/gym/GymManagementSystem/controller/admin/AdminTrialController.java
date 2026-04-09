package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
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
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<TrialRegistration> trialPage = trialRegistrationService.searchTrials(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý đăng ký tập thử");
        model.addAttribute("activePage", "trials");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("trialPage", trialPage);

        return "admin/trials/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        TrialRegistration trialRegistration = new TrialRegistration();
        trialRegistration.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm đăng ký tập thử");
        model.addAttribute("activePage", "trials");
        model.addAttribute("trialRegistration", trialRegistration);
        model.addAttribute("isEdit", false);

        return "admin/trials/form";
    }

    @PostMapping("/create")
    public String createTrial(
            @Valid @ModelAttribute("trialRegistration") TrialRegistration trialRegistration,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký tập thử");
            model.addAttribute("activePage", "trials");
            model.addAttribute("isEdit", false);
            return "admin/trials/form";
        }

        trialRegistrationService.createTrial(trialRegistration);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký tập thử thành công");
        return "redirect:/admin/trials";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        TrialRegistration trialRegistration = trialRegistrationService.getTrialById(id);
        if (trialRegistration == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tập thử");
            return "redirect:/admin/trials";
        }

        model.addAttribute("pageTitle", "Cập nhật đăng ký tập thử");
        model.addAttribute("activePage", "trials");
        model.addAttribute("trialRegistration", trialRegistration);
        model.addAttribute("isEdit", true);

        return "admin/trials/form";
    }

    @PostMapping("/edit/{id}")
    public String updateTrial(
            @PathVariable Integer id,
            @Valid @ModelAttribute("trialRegistration") TrialRegistration trialRegistration,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (trialRegistrationService.getTrialById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tập thử");
            return "redirect:/admin/trials";
        }

        if (bindingResult.hasErrors()) {
            trialRegistration.setTrialId(id);
            model.addAttribute("pageTitle", "Cập nhật đăng ký tập thử");
            model.addAttribute("activePage", "trials");
            model.addAttribute("isEdit", true);
            return "admin/trials/form";
        }

        trialRegistrationService.updateTrial(id, trialRegistration);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký tập thử thành công");
        return "redirect:/admin/trials";
    }

    @PostMapping("/delete/{id}")
    public String deleteTrial(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = trialRegistrationService.cancelTrial(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký tập thử thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký tập thử");
        }

        return "redirect:/admin/trials";
    }
}