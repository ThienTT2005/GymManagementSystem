package com.gym.GymManagementSystem.controller.receptionist;

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
@RequestMapping("/receptionist/members")
public class ReceptionistMemberController {

    private final MemberService memberService;

    public ReceptionistMemberController(MemberService memberService) {
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

        return "receptionist/members/list";
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

        return "receptionist/members/form";
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
            return "receptionist/members/form";
        }

        memberService.createMember(member, userId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm hội viên thành công");
        return "redirect:/receptionist/members";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/receptionist/members";
        }

        model.addAttribute("pageTitle", "Cập nhật hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("users", memberService.getAllUsers());
        model.addAttribute("isEdit", true);

        return "receptionist/members/form";
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
        if (bindingResult.hasErrors()) {
            member.setMemberId(id);
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("users", memberService.getAllUsers());
            model.addAttribute("isEdit", true);
            return "receptionist/members/form";
        }

        Member updated = memberService.updateMember(id, member, userId);
        if (updated == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/receptionist/members";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hội viên thành công");
        return "redirect:/receptionist/members";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/receptionist/members";
        }

        model.addAttribute("pageTitle", "Chi tiết hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);

        return "receptionist/members/detail";
    }
}