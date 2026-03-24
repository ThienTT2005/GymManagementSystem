package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.TrialRegistration;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/trials")
public class AdminTrialController {

    private final TrialRegistrationService trialRegistrationService;

    public AdminTrialController(TrialRegistrationService trialRegistrationService) {
        this.trialRegistrationService = trialRegistrationService;
    }

    @GetMapping
    public String listTrials(Model model) {
        model.addAttribute("pageTitle", "Đăng ký tập thử");
        model.addAttribute("trialList", trialRegistrationService.findAll());
        return "admin/trials/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        TrialRegistration trialRegistration = new TrialRegistration();
        trialRegistration.setRegisterDate(LocalDate.now());
        trialRegistration.setStatus("Chờ liên hệ");

        model.addAttribute("pageTitle", "Thêm đăng ký tập thử");
        model.addAttribute("trial", trialRegistration);
        return "admin/trials/form";
    }

    @PostMapping("/save")
    public String saveTrial(@ModelAttribute("trial") TrialRegistration trialRegistration) {
        if (trialRegistration.getRegisterDate() == null) {
            trialRegistration.setRegisterDate(LocalDate.now());
        }
        if (trialRegistration.getStatus() == null || trialRegistration.getStatus().isBlank()) {
            trialRegistration.setStatus("Chờ liên hệ");
        }
        trialRegistrationService.save(trialRegistration);
        return "redirect:/admin/trials";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        TrialRegistration trialRegistration = trialRegistrationService.findById(id);
        model.addAttribute("pageTitle", "Sửa đăng ký tập thử");
        model.addAttribute("trial", trialRegistration);
        return "admin/trials/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteTrial(@PathVariable Long id) {
        trialRegistrationService.deleteById(id);
        return "redirect:/admin/trials";
    }
}