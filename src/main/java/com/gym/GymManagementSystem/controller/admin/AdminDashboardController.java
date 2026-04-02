package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.service.DashboardService;
import com.gym.GymManagementSystem.service.PaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminDashboardController {

    private final DashboardService dashboardService;
    private final PaymentService paymentService;

    public AdminDashboardController(DashboardService dashboardService,
                                    PaymentService paymentService) {
        this.dashboardService = dashboardService;
        this.paymentService = paymentService;
    }

    @GetMapping("/admin")
    public String adminRoot() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/admin/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("pageTitle", "Admin Dashboard");

        model.addAttribute("totalMembers", dashboardService.getTotalMembers());
        model.addAttribute("activePackages", dashboardService.getActivePackages());
        model.addAttribute("pendingPayments", dashboardService.getPendingPayments());
        model.addAttribute("totalServices", dashboardService.getTotalServices());
        model.addAttribute("totalBranches", dashboardService.getTotalBranches());

        model.addAttribute("pendingPaymentList", dashboardService.getPendingPaymentList());
        model.addAttribute("trialList", dashboardService.getPendingTrialList());
        model.addAttribute("todayClasses", dashboardService.getTodaySchedules());

        model.addAttribute("monthlyRevenue", paymentService.getMonthlyRevenueComparison());
        model.addAttribute("currentYear", java.time.Year.now().getValue());
        model.addAttribute("previousYear", java.time.Year.now().getValue() - 1);

        return "admin/dashboard";
    }
}