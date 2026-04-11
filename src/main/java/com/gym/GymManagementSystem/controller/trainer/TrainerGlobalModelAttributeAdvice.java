package com.gym.GymManagementSystem.controller.trainer;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import com.gym.GymManagementSystem.service.TrainerService;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Collections;
import java.util.List;

@ControllerAdvice(basePackages = "com.gym.GymManagementSystem.controller.trainer")
public class TrainerGlobalModelAttributeAdvice {

    private final NotificationService notificationService;
    private final TrainerService trainerService;
    private final UserService userService;

    public TrainerGlobalModelAttributeAdvice(NotificationService notificationService,
                                             TrainerService trainerService,
                                             UserService userService) {
        this.notificationService = notificationService;
        this.trainerService = trainerService;
        this.userService = userService;
    }

    @ModelAttribute("loggedInUser")
    public User loggedInUser(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return null;
        }
        return userService.getUserById(user.getUserId());
    }

    @ModelAttribute("trainerProfile")
    public Trainer trainerProfile(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return null;
        }
        return trainerService.getTrainerByUserId(user.getUserId());
    }

    @ModelAttribute("headerNotifications")
    public List<Notification> headerNotifications(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return Collections.emptyList();
        }
        return notificationService.getLatestNotificationsByUserId(user.getUserId(), 10);
    }

    @ModelAttribute("unreadNotificationCount")
    public long unreadNotificationCount(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return 0;
        }
        return notificationService.countUnreadByUserId(user.getUserId());
    }

    private User getLoggedInUser(HttpSession session) {
        Object obj = session.getAttribute("loggedInUser");
        return obj instanceof User user ? user : null;
    }
}