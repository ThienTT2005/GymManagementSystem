package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.StaffService;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/profile")
public class ReceptionistProfileController {

    private final UserService userService;
    private final StaffService staffService;

    public ReceptionistProfileController(UserService userService, StaffService staffService) {
        this.userService = userService;
        this.staffService = staffService;
    }

    @GetMapping
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());
        Staff staff = staffService.getStaffByUserId(user.getUserId());

        model.addAttribute("pageTitle", "Hồ sơ cá nhân");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("staff", staff);

        return "receptionist/profile";
    }

    @GetMapping("/edit")
    public String editProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());
        Staff staff = staffService.getStaffByUserId(user.getUserId());

        model.addAttribute("pageTitle", "Cập nhật hồ sơ");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("staff", staff);

        return "receptionist/edit-profile";
    }

    @PostMapping("/edit")
    public String editProfileSubmit(@RequestParam String username,
                                    @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User updated = userService.updateOwnProfile(user.getUserId(), username);
            staffService.updateOwnAvatar(user.getUserId(), avatarFile);

            if (updated != null) {
                session.setAttribute("loggedInUser", updated);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/receptionist/profile/edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể cập nhật hồ sơ");
            return "redirect:/receptionist/profile/edit";
        }

        return "redirect:/receptionist/profile";
    }

    @GetMapping("/change-password")
    public String changePassword(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("pageTitle", "Đổi mật khẩu");
        model.addAttribute("activePage", "profile");
        return "receptionist/change-password";
    }

    @PostMapping("/change-password")
    public String changePasswordSubmit(@RequestParam String currentPassword,
                                       @RequestParam String newPassword,
                                       @RequestParam String confirmPassword,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userService.changePassword(
                    user.getUserId(),
                    currentPassword,
                    newPassword,
                    confirmPassword
            );
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể đổi mật khẩu");
        }

        return "redirect:/receptionist/profile/change-password";
    }
}