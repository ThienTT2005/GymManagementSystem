package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.User;
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

    public ReceptionistProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());
        model.addAttribute("pageTitle", "Hồ sơ cá nhân");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);

        return "receptionist/profile";
    }

    @GetMapping("/edit")
    public String editProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());
        model.addAttribute("pageTitle", "Cập nhật hồ sơ");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);

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

        User updated = userService.updateOwnProfile(user.getUserId(), username, avatarFile);
        session.setAttribute("loggedInUser", updated);

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công");
        return "redirect:/receptionist/profile";
    }

    @GetMapping("/change-password")
    public String changePassword(Model model) {
        model.addAttribute("pageTitle", "Đổi mật khẩu");
        model.addAttribute("activePage", "profile");
        return "receptionist/change-password";
    }

    @PostMapping("/change-password")
    public String changePasswordSubmit(@RequestParam String currentPassword,
                                       @RequestParam String newPassword,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        boolean ok = userService.changePassword(user.getUserId(), currentPassword, newPassword);

        if (ok) {
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu hiện tại không đúng");
        }

        return "redirect:/receptionist/profile/change-password";
    }
}