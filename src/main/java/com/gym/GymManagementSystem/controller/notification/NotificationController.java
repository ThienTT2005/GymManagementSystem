package com.gym.GymManagementSystem.controller.notification;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/mark-all-read")
    public RedirectView markAllRead(@RequestParam(required = false) String target, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return new RedirectView("/login");
        }

        notificationService.markAllAsRead(loggedInUser.getUserId());
        String redirectTarget = (target == null || target.isBlank()) ? resolveDefaultTargetByRole(loggedInUser) : target;
        return new RedirectView(redirectTarget);
    }

    @GetMapping("/go")
    public RedirectView go(@RequestParam Integer id,
                           @RequestParam(required = false) String target,
                           HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return new RedirectView("/login");
        }

        Notification notification = notificationService.getNotificationByIdForUser(id, loggedInUser.getUserId());
        if (notification == null) {
            return new RedirectView(resolveDefaultTargetByRole(loggedInUser));
        }

        notificationService.markAsRead(id, loggedInUser.getUserId());

        String redirectTarget = notification.getTargetUrl();
        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            redirectTarget = resolveDefaultTargetByRole(loggedInUser);
        }

        if (redirectTarget == null || redirectTarget.isBlank()) {
            redirectTarget = target;
        }

        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            redirectTarget = resolveDefaultTargetByRole(loggedInUser);
        }

        return new RedirectView(redirectTarget);
    }

    private boolean isAllowedTargetForRole(String targetUrl, User user) {
        if (targetUrl == null || targetUrl.isBlank() || user == null || user.getRoleName() == null) {
            return false;
        }

        String roleName = user.getRoleName().trim().toUpperCase();
        String url = targetUrl.trim();

        if ("ADMIN".equals(roleName)) {
            return url.startsWith("/admin/");
        }
        if ("RECEPTIONIST".equals(roleName)) {
            return url.startsWith("/receptionist/");
        }
        if ("TRAINER".equals(roleName)) {
            return url.startsWith("/trainer/");
        }
        if ("MEMBER".equals(roleName)) {
            return url.startsWith("/member/");
        }

        return false;
    }

    private String resolveDefaultTargetByRole(User user) {
        if (user == null || user.getRoleName() == null) {
            return "/login";
        }

        String roleName = user.getRoleName().trim();

        if ("ADMIN".equalsIgnoreCase(roleName)) {
            return "/admin/dashboard";
        }
        if ("RECEPTIONIST".equalsIgnoreCase(roleName)) {
            return "/receptionist/dashboard";
        }
        if ("TRAINER".equalsIgnoreCase(roleName)) {
            return "/trainer/dashboard";
        }
        if ("MEMBER".equalsIgnoreCase(roleName)) {
            return "/member/dashboard";
        }

        return "/login";
    }
}