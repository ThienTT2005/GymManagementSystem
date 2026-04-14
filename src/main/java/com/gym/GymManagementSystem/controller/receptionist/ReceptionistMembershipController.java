package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.service.MembershipService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/memberships")
public class ReceptionistMembershipController {

    private final MembershipService membershipService;

    public ReceptionistMembershipController(MembershipService membershipService) {
        this.membershipService = membershipService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "") String keyword,
                       @RequestParam(required = false) String status,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "8") int size,
                       Model model) {

        Page<Membership> membershipPage = membershipService.searchMemberships(keyword, status, page, size);

        model.addAttribute("pageTitle", "Đăng ký gói tập");
        model.addAttribute("activePage", "memberships");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("membershipPage", membershipPage);

        return "receptionist/memberships/list";
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

        return "receptionist/memberships/form";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute("membership") Membership membership,
                         BindingResult bindingResult,
                         @RequestParam(required = false) Integer memberId,
                         @RequestParam(required = false) Integer packageId,
                         Model model,
                         RedirectAttributes redirectAttributes) {

        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }
        if (packageId == null) {
            bindingResult.reject("packageId", "Vui lòng chọn gói tập");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký gói tập");
            model.addAttribute("activePage", "memberships");
            model.addAttribute("members", membershipService.getAllMembers());
            model.addAttribute("packages", membershipService.getAllPackages());
            model.addAttribute("isEdit", false);
            return "receptionist/memberships/form";
        }

        try {
            membershipService.createMembership(membership, memberId, packageId);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký gói tập thành công");
            return "redirect:/receptionist/memberships";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Thêm đăng ký gói tập");
            model.addAttribute("activePage", "memberships");
            model.addAttribute("members", membershipService.getAllMembers());
            model.addAttribute("packages", membershipService.getAllPackages());
            model.addAttribute("isEdit", false);
            model.addAttribute("errorMessage", e.getMessage());
            return "receptionist/memberships/form";
        }
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            membershipService.approve(id);
            redirectAttributes.addFlashAttribute("successMessage", "Duyệt gói tập thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể duyệt gói tập");
        }
        return "redirect:/receptionist/memberships";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            membershipService.reject(id);
            redirectAttributes.addFlashAttribute("successMessage", "Từ chối gói tập thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể từ chối gói tập");
        }
        return "redirect:/receptionist/memberships";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = membershipService.softDeleteMembership(id, "RECEPTIONIST");

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Hủy đăng ký gói tập thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đăng ký gói tập");
        }

        return "redirect:/receptionist/memberships";
    }
}