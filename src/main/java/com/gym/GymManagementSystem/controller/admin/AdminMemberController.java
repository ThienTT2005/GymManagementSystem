package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.Membership;
import com.gym.GymManagementSystem.service.MembershipService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/members")
public class AdminMemberController {

    private final MembershipService membershipService;

    public AdminMemberController(MembershipService membershipService) {
        this.membershipService = membershipService;
    }

    @GetMapping
    public String listMembers(@RequestParam(value = "keyword", required = false) String keyword,
                              @RequestParam(value = "status", required = false) String status,
                              @RequestParam(value = "page", defaultValue = "0") int page,
                              @RequestParam(value = "size", defaultValue = "5") int size,
                              Model model) {

        var membershipPage = membershipService.searchMemberships(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý hội viên");
        model.addAttribute("memberships", membershipPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", membershipPage.getTotalPages());
        model.addAttribute("size", size);

        return "admin/members/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Membership membership = new Membership();
        membership.setStartDate(LocalDate.now());
        membership.setEndDate(LocalDate.now().plusMonths(1));
        membership.setStatus("Đang hoạt động");

        model.addAttribute("pageTitle", "Thêm hội viên");
        model.addAttribute("membership", membership);
        return "admin/members/form";
    }

    @PostMapping("/save")
    public String saveMember(@ModelAttribute("membership") Membership membership) {

        LocalDate today = LocalDate.now();

        if (membership.getStartDate() == null) {
            membership.setStartDate(today);
        }

        if (membership.getEndDate() == null) {
            membership.setEndDate(membership.getStartDate().plusMonths(1));
        }

        // 👇 LOGIC QUAN TRỌNG
        if (membership.getEndDate().isBefore(today)) {
            membership.setStatus("Hết hạn");
        } else if (membership.getStatus() == null || membership.getStatus().isBlank()) {
            membership.setStatus("Đang hoạt động");
        }

        membershipService.save(membership);
        return "redirect:/admin/members";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Membership membership = membershipService.findById(id);
        model.addAttribute("pageTitle", "Sửa hội viên");
        model.addAttribute("membership", membership);
        return "admin/members/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteMember(@PathVariable Long id) {
        membershipService.deleteById(id);
        return "redirect:/admin/members";
    }

    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Long id) {
        membershipService.toggleStatus(id);
        return "redirect:/admin/members";
    }
}