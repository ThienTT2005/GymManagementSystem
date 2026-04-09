package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.service.MemberService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/members")
public class AdminMemberController {

    private final MemberService memberService;

    public AdminMemberController(MemberService memberService) {
        this.memberService = memberService;
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
        model.addAttribute("users", memberService.getAllUsers());
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
        if (userId != null && memberService.existsByUserId(userId, null)) {
            bindingResult.reject("userId", "Tài khoản này đã được gán cho hội viên khác");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAllUsers());
            model.addAttribute("isEdit", false);
            return "admin/members/form";
        }

        memberService.createMember(member, userId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm hội viên thành công");
        return "redirect:/admin/members";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        model.addAttribute("pageTitle", "Cập nhật hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("users", memberService.getAllUsers());
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
        if (memberService.getMemberById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/admin/members";
        }

        if (userId != null && memberService.existsByUserId(userId, id)) {
            bindingResult.reject("userId", "Tài khoản này đã được gán cho hội viên khác");
        }

        if (bindingResult.hasErrors()) {
            member.setMemberId(id);
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAllUsers());
            model.addAttribute("isEdit", true);
            return "admin/members/form";
        }

        memberService.updateMember(id, member, userId);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hội viên thành công");
        return "redirect:/admin/members";
    }

    @PostMapping("/delete/{id}")
    public String deleteMember(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = memberService.softDeleteMember(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Xóa hội viên thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
        }

        return "redirect:/admin/members";
    }
}