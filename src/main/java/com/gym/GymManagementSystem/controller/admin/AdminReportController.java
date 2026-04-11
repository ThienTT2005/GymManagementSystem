package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.service.ReportService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AdminReportController {

    private final ReportService reportService;

    public AdminReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping("/admin/reports")
    public String showReport(@RequestParam(defaultValue = "0") int monthLimit,
                             @RequestParam(defaultValue = "0") int packageLimit,
                             @RequestParam(defaultValue = "0") int serviceLimit,
                             @RequestParam(defaultValue = "0") int memberLimit,
                             Model model) {
        model.addAttribute("pageTitle", "Báo cáo & thống kê");
        model.addAttribute("activePage", "reports");

        try {
            model.addAttribute("totalRevenue", reportService.getTotalRevenue());
            model.addAttribute("totalMembers", reportService.countMembers());
            model.addAttribute("totalPayments", reportService.countTotalPayments());
            model.addAttribute("pendingPayments", reportService.countPendingPayments());
            model.addAttribute("totalTrials", reportService.countTrialRegistrations());
            model.addAttribute("totalContacts", reportService.countContacts());

            model.addAttribute("monthLimit", monthLimit);
            model.addAttribute("packageLimit", packageLimit);
            model.addAttribute("serviceLimit", serviceLimit);
            model.addAttribute("memberLimit", memberLimit);

            model.addAttribute("revenueRows", reportService.getMonthlyRevenueRows(monthLimit));
            model.addAttribute("packageRevenueRows", reportService.getPackageRevenueRows(packageLimit));
            model.addAttribute("serviceRevenueRows", reportService.getServiceRevenueRows(serviceLimit));
            model.addAttribute("loyalMemberRows", reportService.getLoyalMemberRows(memberLimit));

            model.addAttribute("reportAvailable", true);

        } catch (Exception ex) {
            model.addAttribute("reportAvailable", false);
            model.addAttribute("errorMessage", "Tính năng báo cáo đang được cập nhật");
        }

        return "admin/reports/index";
    }
}