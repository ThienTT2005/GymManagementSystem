package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.*;
import com.gym.GymManagementSystem.model.Package;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

// @Controller: đánh dấu đây là Controller (khác với @RestController trả JSON)
// @RequestMapping: tất cả URL trong class này đều bắt đầu bằng /member
// @RequiredArgsConstructor (Lombok): inject MemberService tự động
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final UserRepository userRepository;

    // Đọc từ application.properties: file.upload-dir=uploads
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    // =============================================
    //   Helper: lấy user từ session, nếu chưa
    //   login thì trả về null (AuthFilter sẽ chặn)
    // =============================================
    private Member getMemberFromSession(HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return null;
        return memberService.getProfile(user.getUserId());
    }

    // =============================================
    //   MOCK LOGIN — chỉ để test, xóa khi merge
    // =============================================
    @GetMapping("/mock-login")
    public String mockLogin(HttpSession session) {
        User user = userRepository.findById(1).orElse(null);
        if (user != null) session.setAttribute("loggedUser", user);
        return "redirect:/member/dashboard";
    }

    // =============================================
    //   ĐĂNG XUẤT
    // =============================================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // xóa toàn bộ session
        return "redirect:/login";
    }

    // =============================================
    //   GET /member/dashboard
    // =============================================
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        Membership membership = memberService.getActiveMembership(member.getMemberId());
        model.addAttribute("member", member);
        model.addAttribute("membership", membership);

        // Lấy lịch tập của lớp đang đăng ký
        model.addAttribute("classRegistrations",
                memberService.getClassRegistrationHistory(member.getMemberId())
                        .stream()
                        .filter(cr -> "active".equals(cr.getStatus()))
                        .toList()
        );
        return "member/dashboard";
    }

    // =============================================
    //   GET /member/profile
    // =============================================
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        model.addAttribute("member", member);
        return "member/profile";
    }

    // =============================================
    //   POST /member/update-profile
    // =============================================
    // @RequestParam: lấy giá trị từ form (thay req.getParameter())
    // RedirectAttributes: truyền thông báo khi redirect
    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String email,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String gender,
                                @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDate dob,
                                @RequestParam(required = false) MultipartFile avatar,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) throws IOException {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        String error = memberService.updateProfile(member.getUser().getUserId(), fullName, email, phone, address,gender, dob, avatar);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            // Cập nhật lại session
//            session.setAttribute("loggedUser", memberService.getProfile(member.getUser().getUserId()));
            redirectAttributes.addFlashAttribute("success", true);
        }
        return "redirect:/member/profile";
    }

    // =============================================
    //   GET /member/schedules?clubId=1
    // =============================================
    @GetMapping("/schedules")
    public String schedules(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        // Lấy các class_registration active của member
        List<ClassRegistration> myClasses =
                memberService.getMyActivePendingClasses(member.getMemberId());
        model.addAttribute("myClasses", myClasses);
        return "member/schedules";
    }
    //  GET /member/classes
    @GetMapping("/classes")
    public String classes(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        model.addAttribute("classes", memberService.getAllActiveClasses());
        return "member/classes";
    }

    // =============================================
    //   GET /member/packages
    // =============================================
    @GetMapping("/packages")
    public String packages(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        model.addAttribute("packages", memberService.getAllActivePackages());
        model.addAttribute("activeMembership", memberService.getActiveMembership(member.getMemberId()));
        model.addAttribute("pendingMembership", memberService.getPendingMembership(member.getMemberId()));
        return "member/packages";
    }

    // =============================================
    //   GET /member/register-package - để xác nhận khi đăng ký
    // =============================================
    @GetMapping("/register-package")
    public String showRegisterPackage(@RequestParam Integer packageId, HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        model.addAttribute("selectedPackage", memberService.getPackageById(packageId));
        return "member/register_package";
    }

    // =============================================
    //   POST /member/register-package
    // =============================================
    @PostMapping("/register-package")
    public String handleRegisterPackage(@RequestParam Integer packageId,
                                        @RequestParam String action,
                                        HttpSession session,
                                        RedirectAttributes redirectAttributes) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

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
        else if(membershipId == -3) {
            redirectAttributes.addFlashAttribute("error", "having_pending");
            return "redirect:/member/packages";
        }
        if (membershipId <= 0) {
            redirectAttributes.addFlashAttribute("error", "failed");
            return "redirect:/member/packages";
        }

        Package pkg = memberService.getPackageById(packageId);

        memberService.createPayment(membershipId, null, pkg.getPrice());

        redirectAttributes.addAttribute("membershipId", membershipId);
        return "redirect:/member/payment";
    }
    // =============================================
    //   POST /member/register-class
    // =============================================
    @PostMapping("/register-class")
    public String registerClass(
            @RequestParam Integer classId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        int classRegistrationId = memberService.registerClass(member.getMemberId(), classId);

        switch (classRegistrationId) {
            case 0  -> redirectAttributes.addFlashAttribute("success", "class_registered");
            case -2 -> redirectAttributes.addFlashAttribute("error", "already_registered");
            case -3 -> redirectAttributes.addFlashAttribute("error", "class_full");
            default -> redirectAttributes.addFlashAttribute("error", "failed");
        }
        if(classRegistrationId < 0) return "redirect:/member/classes";
        Classes classes = memberService.getClassesById(classId);

        memberService.createPayment(null, classRegistrationId, classes.getService().getPrice());
        redirectAttributes.addAttribute("classRegistrationId", classRegistrationId);
        return "redirect:/member/payment";
    }

    // =============================================
    //   GET /member/my-membership
    // =============================================
    @GetMapping("/my-membership")
    public String myMembership(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        Membership membership = memberService.getActiveMembership(member.getMemberId());
        model.addAttribute("membership", membership);
        Membership pendingMembership = memberService.getPendingMembership(member.getMemberId());
        model.addAttribute("pendingMembership", pendingMembership);
        if (pendingMembership != null) {
            model.addAttribute("payment",
                    memberService.getPaymentByMembershipId(pendingMembership.getMembershipId()));
        }
        return "member/my_membership";
    }

    // =============================================
    //   GET /member/payment
    // =============================================
    @GetMapping("/payment")
    public String payment(@RequestParam(required = false) Integer membershipId,
                          @RequestParam(required = false) Integer classRegistrationId,
                          HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        if(membershipId != null ) {
            Membership membership = memberService.getMembershipByMembershipId(membershipId);
            List<Membership> check = memberService.getMembershipHistory(member.getMemberId());
            if (membership == null) {
                return "redirect:/member/packages";
            }
            if(!check.contains(membership)) return "redirect:/member/my-membership";

            model.addAttribute("payment",
                    memberService.getPaymentByMembershipId(membershipId));
            model.addAttribute("membership", membership);
            model.addAttribute("pkg", membership.getPkg());
        }
        if(classRegistrationId != null){
            ClassRegistration cr = memberService.getClassRegistrationByClassRegistrationId(classRegistrationId);
            List<ClassRegistration> check = memberService.getClassRegistrationHistory(member.getMemberId());
            if(cr == null) return "redirect:/member/classes";
            if(!check.contains(cr)) return "redirect:/member/schedules";

            model.addAttribute("classRegistration", cr);
            model.addAttribute("payment", memberService.getPaymentByClassRegistrationId(classRegistrationId));
        }
        return "member/payment";
    }

    // =============================================
    //   POST /member/upload-proof
    // =============================================
    // @RequestParam MultipartFile: Spring tự nhận file upload
    @PostMapping("/upload-proof")
    public String uploadProof(@RequestParam(required = false) Integer membershipId,
                                @RequestParam(required = false) Integer classRegistrationId,
                                @RequestParam("proofImage") MultipartFile file,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) throws IOException {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        if(membershipId != null ) {
            boolean ok = memberService.uploadPaymentProof(membershipId, null, file, uploadDir);
            if (ok) {
                redirectAttributes.addFlashAttribute("success", "uploaded");
            } else {
                redirectAttributes.addFlashAttribute("error", "upload_failed");
            }
            return "redirect:/member/my-membership";
        }
        if(classRegistrationId != null){
            boolean ok = memberService.uploadPaymentProof(null, classRegistrationId, file, uploadDir);
            if (ok) {
                redirectAttributes.addFlashAttribute("success", "uploaded");
            } else {
                redirectAttributes.addFlashAttribute("error", "upload_failed");
            }
            return  "redirect:/member/schedules";
        }
        return "redirect:/member/dashboard";
    }

    // =============================================
//   POST /member/cancel-class
// =============================================
    @PostMapping("/cancel-class")
    public String cancelClass(
            @RequestParam Integer classRegistrationId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        boolean ok = memberService.cancelClass(classRegistrationId, member.getMemberId());
        redirectAttributes.addFlashAttribute(
                ok ? "success" : "error",
                ok ? "class_cancelled" : "failed");
        return "redirect:/member/history";
    }

    // =============================================
//   POST /member/cancel-membership
// =============================================
    @PostMapping("/cancel-membership")
    public String cancelMembership(
            @RequestParam Integer membershipId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";

        boolean ok = memberService.cancelMembership(membershipId, member.getMemberId());
        if (ok) {
            redirectAttributes.addFlashAttribute("success", "membership_cancelled");
        } else {
            redirectAttributes.addFlashAttribute("error", "cannot_cancel");
            // Lý do: chỉ huỷ được khi status = pending
        }
        return "redirect:/member/my-membership";
    }
    // =============================================
    //   GET /member/history
    // =============================================
    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        Member member = getMemberFromSession(session);
        if (member == null) return "redirect:/login";
        model.addAttribute("payments", memberService.getPaymentHistory(member.getMemberId()));
        model.addAttribute("memberships", memberService.getMembershipHistory(member.getMemberId()));
        model.addAttribute("classRegistrations", memberService.getClassRegistrationHistory(member.getMemberId()));
        return "member/history";
    }

}
