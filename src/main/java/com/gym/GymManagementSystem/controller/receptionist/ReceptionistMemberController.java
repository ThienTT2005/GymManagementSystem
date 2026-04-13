package com.gym.GymManagementSystem.controller.receptionist;

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

@Controller
@RequestMapping("/receptionist/members")
public class ReceptionistMemberController {

    private final MemberService memberService;
    private final MembershipService membershipService;
    private final ClassRegistrationService classRegistrationService;

    public ReceptionistMemberController(MemberService memberService,
                                        MembershipService membershipService,
                                        ClassRegistrationService classRegistrationService) {
        this.memberService = memberService;
        this.membershipService = membershipService;
        this.classRegistrationService = classRegistrationService;
    }

    @GetMapping
    public String listMembers(@RequestParam(defaultValue = "") String keyword,
                              @RequestParam(required = false) Integer status,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "8") int size,
                              Model model) {

        Page<Member> memberPage = memberService.searchMembers(keyword, status, page, size);
        memberPage.getContent().forEach(membershipService::attachCurrentMembershipSummary);

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
        model.addAttribute("isEdit", false);

        return "receptionist/members/form";
    }

    @PostMapping("/create")
    public String createMember(@Valid @ModelAttribute("member") Member member,
                               BindingResult bindingResult,
                               @RequestParam(required = false) String username,
                               @RequestParam(required = false) String password,
                               Model model,
                               RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("isEdit", false);
            model.addAttribute("formUsername", username);
            return "receptionist/members/form";
        }

        try {
            memberService.createMemberWithAccount(member, username, password);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm hội viên thành công");
            return "redirect:/receptionist/members";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Thêm hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("isEdit", false);
            model.addAttribute("formUsername", username);
            model.addAttribute("errorMessage", e.getMessage());
            return "receptionist/members/form";
        }
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
        model.addAttribute("isEdit", true);

        return "receptionist/members/form";
    }

    @PostMapping("/edit/{id}")
    public String updateMember(@PathVariable Integer id,
                               @Valid @ModelAttribute("member") Member member,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            member.setMemberId(id);
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("isEdit", true);
            return "receptionist/members/form";
        }

        try {
            Member updated = memberService.updateMember(id, member, null);
            if (updated == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
                return "redirect:/receptionist/members";
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hội viên thành công");
            return "redirect:/receptionist/members";
        } catch (IllegalArgumentException e) {
            member.setMemberId(id);
            model.addAttribute("pageTitle", "Cập nhật hội viên");
            model.addAttribute("activePage", "members");
            model.addAttribute("isEdit", true);
            model.addAttribute("errorMessage", e.getMessage());
            return "receptionist/members/form";
        }
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy hội viên");
            return "redirect:/receptionist/members";
        }

        membershipService.attachCurrentMembershipSummary(member);

        model.addAttribute("pageTitle", "Chi tiết hội viên");
        model.addAttribute("activePage", "members");
        model.addAttribute("member", member);
        model.addAttribute("currentClassRegistrations", classRegistrationService.findCurrentRegistrationsByMemberId(id));

        return "receptionist/members/detail";
    }
}