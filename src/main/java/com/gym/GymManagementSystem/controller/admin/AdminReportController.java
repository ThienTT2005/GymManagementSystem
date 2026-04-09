//package com.gym.GymManagementSystem.controller.admin;
//
//import com.gym.GymManagementSystem.service.ReportService;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//
//import java.util.ArrayList;
//import java.util.List;
//
//@Controller
//public class AdminReportController {
//
//    private final ReportService reportService;
//
//    public AdminReportController(ReportService reportService) {
//        this.reportService = reportService;
//    }
//
//    @GetMapping("/admin/reports")
//    public String showReport(Model model) {
//        model.addAttribute("pageTitle", "Báo cáo thống kê");
//        model.addAttribute("totalPayments", reportService.countTotalPayments());
//        model.addAttribute("pendingPayments", reportService.countPendingPayments());
//        model.addAttribute("totalRevenue", reportService.getTotalRevenue());
//        model.addAttribute("trialCount", reportService.countTrialRegistrations());
//        model.addAttribute("topPackages", reportService.getTopPackages());
//
//        List<Object[]> monthlyRevenue = reportService.getMonthlyRevenue();
//
//        List<String> labels = new ArrayList<>();
//        List<String> values = new ArrayList<>();
//
//        for (Object[] row : monthlyRevenue) {
//            labels.add("Tháng " + row[0]);
//            values.add(String.valueOf(row[1]));
//        }
//
//        model.addAttribute("revenueLabels", labels);
//        model.addAttribute("revenueValues", values);
//
//        return "admin/reports/index";
//    }
//}