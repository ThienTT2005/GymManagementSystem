package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import com.gym.GymManagementSystem.service.StaffService;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Collections;
import java.util.List;

@ControllerAdvice(basePackages = "com.gym.GymManagementSystem.controller.admin")
public class AdminGlobalModelAttributeAdvice {

    private final NotificationService notificationService;
    private final StaffService staffService;
    private final UserService userService;

    public AdminGlobalModelAttributeAdvice(NotificationService notificationService,
                                           StaffService staffService,
                                           UserService userService) {
        this.notificationService = notificationService;
        this.staffService = staffService;
        this.userService = userService;
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

    @ModelAttribute("staff")
    public Staff currentStaff(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return null;
        }
        return staffService.getStaffByUserId(user.getUserId());
    }

    @ModelAttribute("loggedInUser")
    public User loggedInUser(HttpSession session) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return null;
        }

        User freshUser = userService.getUserById(user.getUserId());
        if (freshUser != null) {
            session.setAttribute("loggedInUser", freshUser);
            return freshUser;
        }
        return user;
    }

    private User getLoggedInUser(HttpSession session) {
        Object obj = session.getAttribute("loggedInUser");
        return obj instanceof User user ? user : null;
    }
}