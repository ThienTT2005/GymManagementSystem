package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.service.MembershipService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
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
    public String showCreateForm(Model model) {
        Membership membership = new Membership();
        membership.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm đăng ký gói tập");
        model.addAttribute("activePage", "memberships");
        model.addAttribute("membership", membership);
        model.addAttribute("members", membershipService.getAllMembers());
        model.addAttribute("packages", membershipService.getAllPackages());
        model.addAttribute("isEdit", false);

        return "admin/memberships/form";
    }

    @PostMapping("/create")
    public String createMembership(
            @Valid @ModelAttribute("membership") Membership membership,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer memberId,
            @RequestParam(required = false) Integer packageId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }

        if (packageId == null) {
            bindingResult.reject("packageId", "Vui lòng chọn gói tập");
        }

        if (membership.getStartDate() != null && membership.getEndDate() != null
                && membership.getEndDate().isBefore(membership.getStartDate())) {
            bindingResult.rejectValue("endDate", "error.endDate",
                    "Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký gói tập");
            model.addAttribute("activePage", "memberships");
            model.addAttribute("members", membershipService.getAllMembers());
            model.addAttribute("packages", membershipService.getAllPackages());
            model.addAttribute("isEdit", false);
            return "admin/memberships/form";
        }

        membershipService.createMembership(membership, memberId, packageId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký gói tập thành công");
        return "redirect:/admin/memberships";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Membership membership = membershipService.getMembershipById(id);
        if (membership == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký gói tập");
            return "redirect:/admin/memberships";
        }

        model.addAttribute("pageTitle", "Cập nhật đăng ký gói tập");
        model.addAttribute("activePage", "memberships");
        model.addAttribute("membership", membership);
        model.addAttribute("members", membershipService.getAllMembers());
        model.addAttribute("packages", membershipService.getAllPackages());
        model.addAttribute("isEdit", true);

        return "admin/memberships/form";
    }

    @PostMapping("/edit/{id}")
    public String updateMembership(
            @PathVariable Integer id,
            @Valid @ModelAttribute("membership") Membership membership,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer memberId,
            @RequestParam(required = false) Integer packageId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (membershipService.getMembershipById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký gói tập");
            return "redirect:/admin/memberships";
        }

        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }

        if (packageId == null) {
            bindingResult.reject("packageId", "Vui lòng chọn gói tập");
        }

        if (membership.getStartDate() != null && membership.getEndDate() != null
                && membership.getEndDate().isBefore(membership.getStartDate())) {
            bindingResult.rejectValue("endDate", "error.endDate",
                    "Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }

        if (bindingResult.hasErrors()) {
            membership.setMembershipId(id);
            model.addAttribute("pageTitle", "Cập nhật đăng ký gói tập");
            model.addAttribute("activePage", "memberships");
            model.addAttribute("members", membershipService.getAllMembers());
            model.addAttribute("packages", membershipService.getAllPackages());
            model.addAttribute("isEdit", true);
            return "admin/memberships/form";
        }

        membershipService.updateMembership(id, membership, memberId, packageId);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký gói tập thành công");
        return "redirect:/admin/memberships";
    }

    @PostMapping("/delete/{id}")
    public String deleteMembership(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = membershipService.softDeleteMembership(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái đăng ký thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký gói tập");
        }

        return "redirect:/admin/memberships";
    }
}