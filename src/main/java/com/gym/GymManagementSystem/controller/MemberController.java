package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.*;
import com.gym.GymManagementSystem.model.Package;
import com.gym.GymManagementSystem.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

// @Controller: đánh dấu đây là Controller (khác với @RestController trả JSON)
// @RequestMapping: tất cả URL trong class này đều bắt đầu bằng /member
// @RequiredArgsConstructor (Lombok): inject MemberService tự động
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    // Đọc từ application.properties: file.upload-dir=uploads
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    // =============================================
    //   Helper: lấy user từ session, nếu chưa
    //   login thì trả về null (AuthFilter sẽ chặn)
    // =============================================
    private User getLoggedUser(HttpSession session) {
        return (User) session.getAttribute("loggedUser");
    }

    // =============================================
    //   GET /member/dashboard
    // =============================================
    // Model: đối tượng Spring dùng để truyền data sang JSP
    //        thay cho req.setAttribute()
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("membership", memberService.getActiveMembership(user.getUserId()));
        model.addAttribute("myClasses", memberService.getMyClasses(user.getUserId()));
        return "member/dashboard"; // Spring tìm: /WEB-INF/views/member/dashboard.jsp
    }

    // =============================================
    //   GET /member/profile
    // =============================================
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("user", memberService.getProfile(user.getUserId()));
        return "member/profile";
    }

    // =============================================
    //   POST /member/update-profile
    // =============================================
    // @RequestParam: lấy giá trị từ form (thay req.getParameter())
    // RedirectAttributes: truyền thông báo khi redirect
    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String email,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        String error = memberService.updateProfile(user.getUserId(), fullName, email, phone, address);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            // Cập nhật lại session
            session.setAttribute("loggedUser", memberService.getProfile(user.getUserId()));
            redirectAttributes.addFlashAttribute("success", true);
        }
        return "redirect:/member/profile";
    }

    // =============================================
    //   GET /member/clubs
    // =============================================
    @GetMapping("/clubs")
    public String clubs(Model model) {
        model.addAttribute("clubs", memberService.getAllClubs());
        return "member/clubs";
    }

    // =============================================
    //   GET /member/schedules?clubId=1
    // =============================================
    // @RequestParam(required = false): tham số không bắt buộc
    @GetMapping("/schedules")
    public String schedules(@RequestParam(required = false) Integer clubId,
                            Model model) {
        if (clubId != null) {
            model.addAttribute("schedules", memberService.getSchedulesByClub(clubId));
        } else {
            model.addAttribute("schedules", memberService.getAllSchedules());
        }
        model.addAttribute("clubs", memberService.getAllClubs());
        model.addAttribute("selectedClubId", clubId);
        return "member/schedules";
    }

    // =============================================
    //   GET /member/packages
    // =============================================
    @GetMapping("/packages")
    public String packages(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("packages", memberService.getAllActivePackages());
        model.addAttribute("currentMembership", memberService.getActiveMembership(user.getUserId()));
        return "member/packages";
    }

    // =============================================
    //   GET /member/register-package?packageId=2
    // =============================================
    @GetMapping("/register-package")
    public String showRegisterPackage(@RequestParam Integer packageId, Model model) {
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
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        int membershipId;
        if ("renew".equals(action)) {
            membershipId = memberService.renewPackage(user.getUserId(), packageId);
        } else {
            membershipId = memberService.registerPackage(user.getUserId(), packageId);
        }

        if (membershipId == -2) {
            redirectAttributes.addFlashAttribute("error", "already_active");
            return "redirect:/member/packages";
        }
        if (membershipId <= 0) {
            redirectAttributes.addFlashAttribute("error", "failed");
            return "redirect:/member/packages";
        }

        Package pkg = memberService.getPackageById(packageId);
        memberService.createPayment(membershipId, pkg.getPrice());

        return "redirect:/member/payment?membershipId=" + membershipId + "&new=1";
    }

    // =============================================
    //   GET /member/my-package
    // =============================================
    @GetMapping("/my-package")
    public String myPackage(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        Membership m = memberService.getActiveMembership(user.getUserId());
        model.addAttribute("membership", m);
        if (m != null) {
            model.addAttribute("payment",
                    memberService.getPaymentByMembershipId(m.getMembershipId()));
        }
        return "member/my_package";
    }

    // =============================================
    //   GET /member/payment?membershipId=5
    // =============================================
    @GetMapping("/payment")
    public String payment(@RequestParam Integer membershipId,
                          HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        Membership m = memberService.getActiveMembership(user.getUserId());
        if (m == null || !m.getMembershipId().equals(membershipId)) {
            return "redirect:/member/my-package";
        }
        model.addAttribute("membership", m);
        model.addAttribute("pkg", m.getPkg());
        return "member/payment";
    }

    // =============================================
    //   POST /member/upload-payment
    // =============================================
    // @RequestParam MultipartFile: Spring tự nhận file upload
    @PostMapping("/upload-payment")
    public String uploadPayment(@RequestParam Integer membershipId,
                                @RequestParam("proofImage") MultipartFile file,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) throws IOException {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        boolean ok = memberService.uploadProofImage(membershipId, file, uploadDir);
        if (ok) {
            redirectAttributes.addFlashAttribute("success", "uploaded");
        } else {
            redirectAttributes.addFlashAttribute("error", "upload_failed");
        }
        return "redirect:/member/my-package";
    }

    // =============================================
    //   POST /member/register-class
    // =============================================
    @PostMapping("/register-class")
    public String registerClass(@RequestParam Integer scheduleId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        int result = memberService.registerClass(user.getUserId(), scheduleId);
        switch (result) {
            case 0  -> redirectAttributes.addFlashAttribute("success", "registered");
            case -2 -> redirectAttributes.addFlashAttribute("error", "already_registered");
            case -3 -> redirectAttributes.addFlashAttribute("error", "class_full");
            default -> redirectAttributes.addFlashAttribute("error", "failed");
        }
        return "redirect:/member/schedules";
    }

    // =============================================
    //   POST /member/cancel-class
    // =============================================
    @PostMapping("/cancel-class")
    public String cancelClass(@RequestParam Integer registrationId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        boolean ok = memberService.cancelClass(registrationId, user.getUserId());
        if (ok) {
            redirectAttributes.addFlashAttribute("success", "cancelled");
        } else {
            redirectAttributes.addFlashAttribute("error", "failed");
        }
        return "redirect:/member/schedules";
    }

    // =============================================
    //   GET /member/history
    // =============================================
    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("memberships", memberService.getMembershipHistory(user.getUserId()));
        model.addAttribute("payments", memberService.getPaymentHistory(user.getUserId()));
        model.addAttribute("classRegs", memberService.getMyClasses(user.getUserId()));
        return "member/history";
    }
}
