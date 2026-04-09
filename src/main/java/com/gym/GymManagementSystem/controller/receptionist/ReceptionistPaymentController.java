package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.service.PaymentService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/payments")
public class ReceptionistPaymentController {

    private final PaymentService paymentService;

    public ReceptionistPaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Payment> paymentPage = paymentService.searchPayments(keyword, status, page, size);

        model.addAttribute("pageTitle", "Thanh toán");
        model.addAttribute("activePage", "payments");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("paymentPage", paymentPage);

        return "receptionist/payments/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Payment payment = new Payment();
        payment.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm thanh toán");
        model.addAttribute("activePage", "payments");
        model.addAttribute("payment", payment);
        model.addAttribute("memberships", paymentService.getAllMemberships());
        model.addAttribute("classRegistrations", paymentService.getAllClassRegistrations());
        model.addAttribute("isEdit", false);

        return "receptionist/payments/form";
    }

    @PostMapping("/create")
    public String create(
            @Valid @ModelAttribute("payment") Payment payment,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer membershipId,
            @RequestParam(required = false) Integer classRegistrationId,
            @RequestParam(value = "proofFile", required = false) MultipartFile proofFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (membershipId == null && classRegistrationId == null) {
            bindingResult.reject("target", "Vui lòng chọn membership hoặc class registration");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm thanh toán");
            model.addAttribute("activePage", "payments");
            model.addAttribute("memberships", paymentService.getAllMemberships());
            model.addAttribute("classRegistrations", paymentService.getAllClassRegistrations());
            model.addAttribute("isEdit", false);
            return "receptionist/payments/form";
        }

        paymentService.createPayment(payment, membershipId, classRegistrationId, proofFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm thanh toán thành công");
        return "redirect:/receptionist/payments";
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        paymentService.approvePayment(id);
        redirectAttributes.addFlashAttribute("successMessage", "Duyệt thanh toán thành công");
        return "redirect:/receptionist/payments";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        paymentService.rejectPayment(id);
        redirectAttributes.addFlashAttribute("successMessage", "Từ chối thanh toán thành công");
        return "redirect:/receptionist/payments";
    }
}