package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import com.gym.GymManagementSystem.service.DashboardService;
import com.gym.GymManagementSystem.service.MembershipService;
import com.gym.GymManagementSystem.service.PaymentService;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    private final DashboardService dashboardService;
    private final MembershipService membershipService;
    private final ClassRegistrationService classRegistrationService;
    private final TrialRegistrationService trialRegistrationService;
    private final PaymentService paymentService;

    public AdminDashboardController(DashboardService dashboardService,
                                    MembershipService membershipService,
                                    ClassRegistrationService classRegistrationService,
                                    TrialRegistrationService trialRegistrationService,
                                    PaymentService paymentService) {
        this.dashboardService = dashboardService;
        this.membershipService = membershipService;
        this.classRegistrationService = classRegistrationService;
        this.trialRegistrationService = trialRegistrationService;
        this.paymentService = paymentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Dashboard Admin");
        model.addAttribute("activePage", "dashboard");

        model.addAttribute("totalMembers", dashboardService.countMembers());
        model.addAttribute("totalStaff", dashboardService.countStaff());
        model.addAttribute("totalTrainers", dashboardService.countTrainers());
        model.addAttribute("totalClasses", dashboardService.countClasses());
        model.addAttribute("totalPackages", dashboardService.countPackages());
        model.addAttribute("totalTrials", dashboardService.countTrials());
        model.addAttribute("totalConsultations", dashboardService.countConsultations());
        model.addAttribute("totalRevenue", dashboardService.getTotalRevenue());

        model.addAttribute("pendingMembershipCount", dashboardService.countPendingMemberships());
        model.addAttribute("pendingClassRegistrationCount", dashboardService.countPendingClassRegistrations());
        model.addAttribute("pendingPayments", dashboardService.countPendingPayments());
        model.addAttribute("pendingTrialCount", dashboardService.countPendingTrials());
        model.addAttribute("pendingConsultationCount", dashboardService.countPendingConsultations());

        model.addAttribute("recentMemberships", membershipService.findPending());
        model.addAttribute("recentClassRegistrations", classRegistrationService.findPending());
        model.addAttribute("recentTrials", trialRegistrationService.findPending());
        model.addAttribute("recentPayments", paymentService.findPending());

        List<String> monthlyRevenueLabels = new ArrayList<>();
        List<BigDecimal> monthlyRevenueValues = new ArrayList<>();
        List<String> paymentStatusLabels = new ArrayList<>();
        List<Long> paymentStatusValues = new ArrayList<>();

        List<Object[]> monthlyRevenue = dashboardService.getMonthlyRevenue();
        for (Object[] row : monthlyRevenue) {
            if (row == null || row.length < 2 || row[0] == null) {
                continue;
            }

            String yearMonth = String.valueOf(row[0]);
            String label = yearMonth;

            if (yearMonth.matches("\\d{4}-\\d{2}")) {
                int monthValue = Integer.parseInt(yearMonth.substring(5, 7));
                label = Month.of(monthValue).getDisplayName(TextStyle.SHORT, new Locale("vi", "VN"));
            }

            monthlyRevenueLabels.add(label);
            monthlyRevenueValues.add(toBigDecimal(row[1]));
        }

        long pendingCount = dashboardService.countPendingPayments();
        long paidCount = dashboardService.countPaidPayments();
        long rejectedCount = dashboardService.countRejectedPayments();
        long cancelledCount = dashboardService.countCancelledPayments();

        if (paidCount > 0) {
            paymentStatusLabels.add("Đã thanh toán");
            paymentStatusValues.add(paidCount);
        }
        if (pendingCount > 0) {
            paymentStatusLabels.add("Chờ xử lý");
            paymentStatusValues.add(pendingCount);
        }
        if (rejectedCount > 0) {
            paymentStatusLabels.add("Từ chối");
            paymentStatusValues.add(rejectedCount);
        }
        if (cancelledCount > 0) {
            paymentStatusLabels.add("Đã hủy");
            paymentStatusValues.add(cancelledCount);
        }

        if (paymentStatusLabels.isEmpty()) {
            paymentStatusLabels.add("Chưa có dữ liệu");
            paymentStatusValues.add(0L);
        }

        model.addAttribute("monthlyRevenueLabels", monthlyRevenueLabels);
        model.addAttribute("monthlyRevenueValues", monthlyRevenueValues);
        model.addAttribute("paymentStatusLabels", paymentStatusLabels);
        model.addAttribute("paymentStatusValues", paymentStatusValues);

        return "admin/dashboard";
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal bigDecimal) {
            return bigDecimal;
        }
        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue());
        }
        try {
            return new BigDecimal(String.valueOf(value));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}