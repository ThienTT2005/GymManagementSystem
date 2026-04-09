package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.DashboardService;
import com.gym.GymManagementSystem.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    private final DashboardService dashboardService;
    private final NotificationService notificationService;

    public AdminDashboardController(DashboardService dashboardService,
                                    NotificationService notificationService) {
        this.dashboardService = dashboardService;
        this.notificationService = notificationService;
    }

    @ModelAttribute("headerNotifications")
    public List<Notification> headerNotifications(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return Collections.emptyList();
        }

        List<Notification> all = notificationService.getLatestNotifications();
        if (all == null) {
            return Collections.emptyList();
        }

        return all.stream()
                .filter(n -> n.getTargetUrl() != null &&
                        (n.getTargetUrl().startsWith("/admin")
                                || n.getTargetUrl().startsWith("/trainer")
                                || n.getTargetUrl().startsWith("/receptionist")))
                .limit(10)
                .collect(Collectors.toList());
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User loggedInUser = getLoggedInUser(session);
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Dashboard Admin");
        model.addAttribute("activePage", "dashboard");
        model.addAttribute("loggedInAdmin", loggedInUser);

        model.addAttribute("totalMembers", dashboardService.countMembers());
        model.addAttribute("totalStaff", dashboardService.countStaff());
        model.addAttribute("totalClasses", dashboardService.countClasses());
        model.addAttribute("totalPackages", dashboardService.countPackages());
        model.addAttribute("totalRevenue", dashboardService.getTotalRevenue());

        model.addAttribute("pendingMembershipCount", dashboardService.countPendingMemberships());
        model.addAttribute("pendingClassRegistrationCount", dashboardService.countPendingServiceRegistrations());
        model.addAttribute("pendingPayments", dashboardService.countPendingPayments());
        model.addAttribute("pendingTrialCount", dashboardService.countPendingTrials());
        model.addAttribute("pendingConsultationCount", dashboardService.countPendingConsultations());

        model.addAttribute("topClasses", dashboardService.getTopClasses());
        model.addAttribute("topPackages", dashboardService.getTopPackages());
        model.addAttribute("monthlyRevenue", dashboardService.getMonthlyRevenue());

        return "admin/dashboard";
    }

    private User getLoggedInUser(HttpSession session) {
        Object loggedIn = session.getAttribute("loggedInUser");
        return loggedIn instanceof User user ? user : null;
    }
}