package com.gym.GymManagementSystem.controller.notification;

import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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

    @GetMapping("/go")
    public RedirectView go(@RequestParam Integer id,
                           @RequestParam(required = false) String target,
                           HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return new RedirectView("/login");
        }

        notificationService.markAsRead(id, loggedInUser.getUserId());

        if (target == null || target.isBlank()) {
            return new RedirectView("/admin/dashboard");
        }

        return new RedirectView(target);
    }
}