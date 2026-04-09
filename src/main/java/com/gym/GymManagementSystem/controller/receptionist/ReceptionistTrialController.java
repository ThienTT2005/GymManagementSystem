package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/trials")
public class ReceptionistTrialController {

    private final TrialRegistrationService trialRegistrationService;

    public ReceptionistTrialController(TrialRegistrationService trialRegistrationService) {
        this.trialRegistrationService = trialRegistrationService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<TrialRegistration> trialPage = trialRegistrationService.searchTrials(keyword, status, page, size);

        model.addAttribute("pageTitle", "Đăng ký tập thử");
        model.addAttribute("activePage", "trials");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("trialPage", trialPage);

        return "receptionist/trials/list";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam String status,
                               RedirectAttributes redirectAttributes) {
        trialRegistrationService.updateStatus(id, status);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái tập thử thành công");
        return "redirect:/receptionist/trials";
    }
}