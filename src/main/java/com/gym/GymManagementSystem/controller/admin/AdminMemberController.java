package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import com.gym.GymManagementSystem.service.MemberService;
import com.gym.GymManagementSystem.service.MembershipService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/members")
public class AdminMemberController {

    private final MemberService memberService;
    private final MembershipService membershipService;
    private final ClassRegistrationService classRegistrationService;

    public AdminMemberController(MemberService memberService,
                                 MembershipService membershipService,
                                 ClassRegistrationService classRegistrationService) {
        this.memberService = memberService;
        this.membershipService = membershipService;
        this.classRegistrationService = classRegistrationService;
    }

    @GetMapping
    public String listMembers(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Member> memberPage = memberService.searchMembers(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("members", memberPage.getContent());
        model.addAttribute("memberPage", memberPage);

        return "admin/members/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Member member = new Member();
        member.setStatus(1);

        model.addAttribute("pageTitle", "Thêm hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("users", memberService.getAssignableUsers());
        model.addAttribute("isEdit", false);

        return "admin/members/form";
    }

    @PostMapping("/create")
    public String createMember(
            @Valid @ModelAttribute("member") Member member,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer userId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAssignableUsers());
            model.addAttribute("isEdit", false);
            return "admin/members/form";
        }

        try {
            memberService.createMember(member, userId);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm hội viên thành công");
            return "redirect:/admin/members";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("pageTitle", "Thêm hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAssignableUsers());
            model.addAttribute("isEdit", false);
            model.addAttribute("errorMessage", ex.getMessage());
            return "admin/members/form";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(
            @PathVariable Integer id,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        model.addAttribute("pageTitle", "Cập nhật hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("users", memberService.getAssignableUsers(id));
        model.addAttribute("isEdit", true);

        return "admin/members/form";
    }

    @PostMapping("/edit/{id}")
    public String updateMember(
            @PathVariable Integer id,
            @Valid @ModelAttribute("member") Member member,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer userId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Member existingMember = memberService.getMemberById(id);
        if (existingMember == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        member.setMemberId(id);

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAssignableUsers(id));
            model.addAttribute("isEdit", true);
            return "admin/members/form";
        }

        try {
            memberService.updateMember(id, member, userId);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hội viên thành công");
            return "redirect:/admin/members";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAssignableUsers(id));
            model.addAttribute("isEdit", true);
            model.addAttribute("errorMessage", ex.getMessage());
            return "admin/members/form";
        }
    }

    @PostMapping("/delete/{id}")
    public String deleteMember(
            @PathVariable Integer id,
            RedirectAttributes redirectAttributes
    ) {
        boolean deleted = memberService.deleteMember(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Ngừng hội viên thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
        }

        return "redirect:/admin/members";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id,
                               RedirectAttributes redirectAttributes) {

        Member member = memberService.getMemberById(id);

        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        int newStatus = (member.getStatus() != null && member.getStatus() == 1) ? 0 : 1;
        memberService.updateStatus(id, newStatus);

        redirectAttributes.addFlashAttribute(
                "successMessage",
                newStatus == 1
                        ? "Kích hoạt hội viên thành công"
                        : "Ngừng hoạt động hội viên thành công"
        );

        return "redirect:/admin/members";
    }

    @GetMapping("/detail/{id}")
    public String showDetail(@PathVariable Integer id,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        membershipService.attachCurrentMembershipSummary(member);
        List<ClassRegistration> currentRegistrations = classRegistrationService.findCurrentRegistrationsByMemberId(id);

        model.addAttribute("pageTitle", "Chi tiết hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("currentRegistrations", currentRegistrations);

        return "admin/members/detail";
    }
}