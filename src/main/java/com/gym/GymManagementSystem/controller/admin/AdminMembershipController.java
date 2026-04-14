package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.service.MembershipService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/memberships")
public class AdminMembershipController {

    private final MembershipService membershipService;

    public AdminMembershipController(MembershipService membershipService) {
        this.membershipService = membershipService;
    }

    @GetMapping
    public String listMemberships(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Membership> membershipPage = membershipService.searchMemberships(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý đăng ký gói tập");
        model.addAttribute("activePage", "memberships");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("membershipPage", membershipPage);

        return "admin/memberships/list";
    }

    @GetMapping("/create")
    public String redirectCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký gói tập. Vui lòng tạo từ luồng Member hoặc Receptionist."
        );
        return "redirect:/admin/memberships";
    }

    @PostMapping("/create")
    public String blockCreate(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không tạo trực tiếp đăng ký gói tập. Vui lòng tạo từ luồng Member hoặc Receptionist."
        );
        return "redirect:/admin/memberships";
    }

    @GetMapping("/edit/{id}")
    public String redirectEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký gói tập. Chỉ được cập nhật trạng thái nghiệp vụ."
        );
        return "redirect:/admin/memberships";
    }

    @PostMapping("/edit/{id}")
    public String blockEdit(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(
                "errorMessage",
                "Admin không chỉnh sửa trực tiếp đăng ký gói tập. Chỉ được cập nhật trạng thái nghiệp vụ."
        );
        return "redirect:/admin/memberships";
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            membershipService.approve(id);
            redirectAttributes.addFlashAttribute("successMessage", "Duyệt đăng ký gói tập thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể duyệt đăng ký gói tập");
        }
        return "redirect:/admin/memberships";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            membershipService.reject(id);
            redirectAttributes.addFlashAttribute("successMessage", "Từ chối đăng ký gói tập thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể từ chối đăng ký gói tập");
        }
        return "redirect:/admin/memberships";
    }

    @PostMapping("/delete/{id}")
    public String deleteMembership(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = membershipService.softDeleteMembership(id, "ADMIN");

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký gói tập thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký gói tập");
        }

        return "redirect:/admin/memberships";
    }
}