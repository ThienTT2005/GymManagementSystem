package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.NotificationService;
import com.gym.GymManagementSystem.service.StaffService;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/admin/profile")
public class AdminProfileController {

    private final UserService userService;
    private final StaffService staffService;
    private final NotificationService notificationService;

    public AdminProfileController(UserService userService,
                                  StaffService staffService,
                                  NotificationService notificationService) {
        this.userService = userService;
        this.staffService = staffService;
        this.notificationService = notificationService;
    }

    @ModelAttribute("headerNotifications")
    public List<Notification> headerNotifications(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return Collections.emptyList();
        }
        return notificationService.getLatestNotificationsByUserId(user.getUserId(), 10);
    }

    @ModelAttribute("unreadNotificationCount")
    public long unreadNotificationCount(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return 0;
        }
        return notificationService.countUnreadByUserId(user.getUserId());
    }

    @GetMapping
    public String profile(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("loggedInUser");

        if (sessionUser == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(sessionUser.getUserId());
        Staff staff = staffService.getStaffByUserId(sessionUser.getUserId());

        model.addAttribute("pageTitle", "Hồ sơ Admin");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("loggedInUser", freshUser);
        model.addAttribute("staff", staff);

        return "admin/profile";
    }

    @GetMapping("/edit")
    public String editProfile(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("loggedInUser");

        if (sessionUser == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(sessionUser.getUserId());
        Staff staff = staffService.getStaffByUserId(sessionUser.getUserId());

        model.addAttribute("pageTitle", "Cập nhật hồ sơ Admin");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("loggedInUser", freshUser);
        model.addAttribute("staff", staff);

        return "admin/edit-profile";
    }

    @PostMapping("/edit")
    public String editProfileSubmit(@RequestParam String username,
                                    @RequestParam(required = false) String fullName,
                                    @RequestParam(required = false) String email,
                                    @RequestParam(required = false) String phone,
                                    @RequestParam(required = false) String address,
                                    @RequestParam(required = false) String gender,
                                    @RequestParam(required = false) LocalDate dob,
                                    @RequestParam("avatarFile") MultipartFile avatarFile,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            User updatedUser = userService.updateOwnProfile(loggedInUser.getUserId(), username);

            staffService.updateOwnProfile(
                    loggedInUser.getUserId(),
                    fullName,
                    email,
                    phone,
                    address,
                    gender,
                    dob,
                    avatarFile
            );

            User freshUser = userService.getUserById(updatedUser.getUserId());
            session.setAttribute("loggedInUser", freshUser);

            Object roleName = session.getAttribute("roleName");
            if (roleName == null) {
                session.setAttribute("roleName", "ADMIN");
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/profile/edit";
        }

        return "redirect:/admin/profile";
    }

    @GetMapping("/change-password")
    public String changePassword(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("loggedInUser");

        if (sessionUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Đổi mật khẩu Admin");
        model.addAttribute("activePage", "profile");
        return "admin/change-password";
    }

    @PostMapping("/change-password")
    public String changePasswordSubmit(@RequestParam String currentPassword,
                                       @RequestParam String newPassword,
                                       @RequestParam String confirmPassword,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {

        User sessionUser = (User) session.getAttribute("loggedInUser");

        if (sessionUser == null) {
            return "redirect:/login";
        }

        try {
            userService.changePassword(
                    sessionUser.getUserId(),
                    currentPassword,
                    newPassword,
                    confirmPassword
            );

            session.invalidate();

            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
            return "redirect:/login";

        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }

        return "redirect:/admin/profile/change-password";
    }
}