package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import com.gym.GymManagementSystem.service.ConsultationService;
import com.gym.GymManagementSystem.service.MemberService;
import com.gym.GymManagementSystem.service.MembershipService;
import com.gym.GymManagementSystem.service.PaymentService;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReceptionistController {

    private final MemberService memberService;
    private final MembershipService membershipService;
    private final ClassRegistrationService classRegistrationService;
    private final PaymentService paymentService;
    private final TrialRegistrationService trialRegistrationService;
    private final ConsultationService consultationService;

    public ReceptionistController(MemberService memberService,
                                  MembershipService membershipService,
                                  ClassRegistrationService classRegistrationService,
                                  PaymentService paymentService,
                                  TrialRegistrationService trialRegistrationService,
                                  ConsultationService consultationService) {
        this.memberService = memberService;
        this.membershipService = membershipService;
        this.classRegistrationService = classRegistrationService;
        this.paymentService = paymentService;
        this.trialRegistrationService = trialRegistrationService;
        this.consultationService = consultationService;
    }

    @GetMapping("/receptionist/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Dashboard Receptionist");
        model.addAttribute("activePage", "dashboard");

        model.addAttribute("totalMembers", memberService.countMembers());
        model.addAttribute("pendingMemberships", membershipService.countPending());
        model.addAttribute("pendingClassRegistrations", classRegistrationService.countPending());
        model.addAttribute("pendingPayments", paymentService.countPending());
        model.addAttribute("pendingTrials", trialRegistrationService.countPending());
        model.addAttribute("pendingConsultations", consultationService.countPending());

        model.addAttribute("recentMemberships", membershipService.findPending());
        model.addAttribute("recentPayments", paymentService.findPending());
        model.addAttribute("recentClassRegistrations", classRegistrationService.findPending());
        model.addAttribute("recentTrials", trialRegistrationService.findPending());
        model.addAttribute("recentConsultations", consultationService.findPending());

        return "receptionist/dashboard";
    }
}