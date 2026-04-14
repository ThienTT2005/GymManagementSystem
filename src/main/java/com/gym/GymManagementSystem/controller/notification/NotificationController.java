package com.gym.GymManagementSystem.controller.notification;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

        String redirectTarget = normalizeTarget(target);
        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            redirectTarget = resolveDefaultTargetByRole(loggedInUser);
        }

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

        String redirectTarget = normalizeTarget(notification.getTargetUrl());

        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            redirectTarget = remapLegacyTargetForRole(redirectTarget, loggedInUser, notification);
        }

        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            String fallbackTarget = normalizeTarget(target);
            if (isAllowedTargetForRole(fallbackTarget, loggedInUser)) {
                redirectTarget = fallbackTarget;
            }
        }

        if (!isAllowedTargetForRole(redirectTarget, loggedInUser)) {
            redirectTarget = resolveDefaultTargetByRole(loggedInUser);
        }

        return new RedirectView(redirectTarget);
    }

    private String normalizeTarget(String targetUrl) {
        if (targetUrl == null) {
            return null;
        }

        String url = targetUrl.trim();
        if (url.isBlank()) {
            return null;
        }

        if (url.startsWith("http://") || url.startsWith("https://")) {
            return null;
        }

        int schemeIndex = url.indexOf("://");
        if (schemeIndex >= 0) {
            return null;
        }

        if (url.startsWith("/notifications/go")) {
            return null;
        }

        if (!url.startsWith("/")) {
            url = "/" + url;
        }

        return url;
    }

    private String remapLegacyTargetForRole(String targetUrl, User user, Notification notification) {
        if (targetUrl == null || user == null || user.getRoleName() == null) {
            return targetUrl;
        }

        String roleName = user.getRoleName().trim().toUpperCase();
        String url = targetUrl.trim();
        String title = notification != null && notification.getTitle() != null
                ? notification.getTitle().trim().toLowerCase()
                : "";
        String message = notification != null && notification.getMessage() != null
                ? notification.getMessage().trim().toLowerCase()
                : "";

        if ("ADMIN".equals(roleName)) {
            if (url.startsWith("/receptionist/trial-requests")) {
                return "/admin/trials";
            }
            if (url.startsWith("/receptionist/consultations")) {
                return "/admin/contacts";
            }
            if (url.startsWith("/receptionist/trials")) {
                return "/admin/trials";
            }
            if (url.startsWith("/receptionist/contacts")) {
                return "/admin/contacts";
            }

            if (title.contains("tập thử") || message.contains("tập thử")) {
                return "/admin/trials";
            }
            if (title.contains("tư vấn") || message.contains("tư vấn")
                    || title.contains("liên hệ") || message.contains("liên hệ")) {
                return "/admin/contacts";
            }
        }

        return targetUrl;
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