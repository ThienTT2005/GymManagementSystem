package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.service.ConsultationService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/consultations")
public class ReceptionistConsultationController {

    private final ConsultationService consultationService;

    public ReceptionistConsultationController(ConsultationService consultationService) {
        this.consultationService = consultationService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Consultation> consultationPage = consultationService.searchConsultations(keyword, status, page, size);

        model.addAttribute("pageTitle", "Yêu cầu tư vấn");
        model.addAttribute("activePage", "consultations");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("consultationPage", consultationPage);

        return "receptionist/consultations/list";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam String status,
                               RedirectAttributes redirectAttributes) {
        consultationService.updateStatus(id, status);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái tư vấn thành công");
        return "redirect:/receptionist/consultations";
    }
}