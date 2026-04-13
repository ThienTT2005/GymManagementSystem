package com.gym.GymManagementSystem.controller.member;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDate;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    private Member getMember(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return null;
        }
        return memberService.getProfile(user.getUserId());
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        Membership membership = memberService.getActiveMembership(member.getMemberId());

        model.addAttribute("member", member);
        model.addAttribute("membership", membership);
        model.addAttribute(
                "classRegistrations",
                memberService.getClassRegistrationHistory(member.getMemberId())
                        .stream()
                        .filter(cr -> "ACTIVE".equalsIgnoreCase(cr.getStatus()))
                        .toList()
        );

        return "member/dashboard";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("member", member);
        return "member/profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String email,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String gender,
                                @RequestParam(required = false)
                                @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dob,
                                @RequestParam(required = false) MultipartFile avatar,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) throws IOException {

        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        String error = memberService.updateProfile(
                member.getUser().getUserId(),
                fullName,
                email,
                phone,
                address,
                gender,
                dob,
                avatar
        );

        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", true);
        }

        return "redirect:/member/profile";
    }

    @GetMapping("/classes")
    public String classes(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("classes", memberService.getAllActiveClasses());
        return "member/classes";
    }

    @PostMapping("/register-class")
    public String registerClass(@RequestParam Integer classId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        int registrationId = memberService.registerClass(member.getMemberId(), classId);

        switch (registrationId) {
            case 0 -> redirectAttributes.addFlashAttribute("success", "class_registered");
            case -2 -> redirectAttributes.addFlashAttribute("error", "already_registered");
            case -3 -> redirectAttributes.addFlashAttribute("error", "class_full");
            default -> redirectAttributes.addFlashAttribute("error", "failed");
        }

        if (registrationId < 0) {
            return "redirect:/member/classes";
        }

        GymClass gymClass = memberService.getClassesById(classId);
        memberService.createPayment(null, registrationId, gymClass.getService().getPrice());

        redirectAttributes.addAttribute("classRegistrationId", registrationId);
        return "redirect:/member/payment";
    }

    @GetMapping("/schedules")
    public String schedules(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("myClasses", memberService.getMyActivePendingClasses(member.getMemberId()));
        return "member/schedules";
    }

    @GetMapping("/packages")
    public String packages(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("packages", memberService.getAllActivePackages());
        model.addAttribute("activeMembership", memberService.getActiveMembership(member.getMemberId()));
        model.addAttribute("pendingMembership", memberService.getPendingMembership(member.getMemberId()));

        return "member/packages";
    }

    @GetMapping("/register-package")
    public String showRegisterPackage(@RequestParam Integer packageId,
                                      HttpSession session,
                                      Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("selectedPackage", memberService.getPackageById(packageId));
        return "member/register_package";
    }

    @PostMapping("/register-package")
    public String registerPackage(@RequestParam Integer packageId,
                                  @RequestParam String action,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {

        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        int membershipId;

        if ("renew".equals(action)) {
            membershipId = memberService.renewMembership(member.getMemberId(), packageId);
            redirectAttributes.addAttribute("isNew", 0);
        } else {
            membershipId = memberService.registerMembership(member.getMemberId(), packageId);
            redirectAttributes.addAttribute("isNew", 1);
        }

        if (membershipId == -2) {
            redirectAttributes.addFlashAttribute("error", "already_active");
            return "redirect:/member/packages";
        }
        if (membershipId == -3) {
            redirectAttributes.addFlashAttribute("error", "having_pending");
            return "redirect:/member/packages";
        }
        if (membershipId <= 0) {
            redirectAttributes.addFlashAttribute("error", "failed");
            return "redirect:/member/packages";
        }

        GymPackage gymPackage = memberService.getPackageById(packageId);
        memberService.createPayment(membershipId, null, gymPackage.getPrice());

        redirectAttributes.addAttribute("membershipId", membershipId);
        return "redirect:/member/payment";
    }

    @GetMapping("/my-membership")
    public String myMembership(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        Membership active = memberService.getActiveMembership(member.getMemberId());
        Membership pending = memberService.getPendingMembership(member.getMemberId());

        model.addAttribute("membership", active);
        model.addAttribute("pendingMembership", pending);

        if (pending != null) {
            model.addAttribute("payment", memberService.getPaymentByMembershipId(pending.getMembershipId()));
        }

        return "member/my_membership";
    }

    @GetMapping("/payment")
    public String payment(@RequestParam(required = false) Integer membershipId,
                          @RequestParam(required = false) Integer classRegistrationId,
                          HttpSession session,
                          Model model) {

        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        if (membershipId != null) {
            Membership membership = memberService.getMembershipByMembershipId(membershipId);
            if (membership == null) {
                return "redirect:/member/packages";
            }

            model.addAttribute("membership", membership);
            model.addAttribute("payment", memberService.getPaymentByMembershipId(membershipId));
        }

        if (classRegistrationId != null) {
            ClassRegistration classRegistration =
                    memberService.getClassRegistrationByClassRegistrationId(classRegistrationId);

            if (classRegistration == null) {
                return "redirect:/member/classes";
            }

            model.addAttribute("classRegistration", classRegistration);
            model.addAttribute("payment", memberService.getPaymentByClassRegistrationId(classRegistrationId));
        }

        return "member/payment";
    }

    @PostMapping("/upload-proof")
    public String uploadProof(@RequestParam(required = false) Integer membershipId,
                              @RequestParam(required = false) Integer classRegistrationId,
                              @RequestParam("proofImage") MultipartFile file,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) throws IOException {

        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        boolean ok = memberService.uploadPaymentProof(
                membershipId,
                classRegistrationId,
                file,
                uploadDir
        );

        redirectAttributes.addFlashAttribute(
                ok ? "success" : "error",
                ok ? "uploaded" : "upload_failed"
        );

        return membershipId != null
                ? "redirect:/member/my-membership"
                : "redirect:/member/schedules";
    }

    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        model.addAttribute("payments", memberService.getPaymentHistory(member.getMemberId()));
        model.addAttribute("memberships", memberService.getMembershipHistory(member.getMemberId()));
        model.addAttribute("classRegistrations", memberService.getClassRegistrationHistory(member.getMemberId()));

        return "member/history";
    }

    @PostMapping("/cancel-membership")
    public String cancelMembership(@RequestParam Integer membershipId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        Member member = getMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        boolean cancelled = memberService.cancelMembership(membershipId, member.getMemberId());

        if (cancelled) {
            redirectAttributes.addFlashAttribute("success", "membership_cancelled");
        } else {
            redirectAttributes.addFlashAttribute("error", "cannot_cancel");
        }

        return "redirect:/member/my-membership";
    }
}