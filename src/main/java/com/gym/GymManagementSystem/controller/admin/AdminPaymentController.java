package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.service.PaymentService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/payments")
public class AdminPaymentController {

    private final PaymentService paymentService;

    public AdminPaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String paymentMethod,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Payment> paymentPage = paymentService.searchPayments(
                keyword, status, paymentMethod, fromDate, toDate, page, size
        );

        model.addAttribute("pageTitle", "Quản lý thanh toán");
        model.addAttribute("activePage", "payments");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("paymentMethod", paymentMethod);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("payments", paymentPage.getContent());
        model.addAttribute("paymentPage", paymentPage);

        return "admin/payments/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(
            @PathVariable Integer id,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Payment payment = paymentService.getPaymentById(id);
        if (payment == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thanh toán");
            return "redirect:/admin/payments";
        }

        model.addAttribute("pageTitle", "Cập nhật thanh toán");
        model.addAttribute("activePage", "payments");
        model.addAttribute("payment", payment);
        model.addAttribute("isEdit", true);

        return "admin/payments/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Integer id,
            @ModelAttribute("payment") Payment payment,
            BindingResult bindingResult,
            @RequestParam(value = "proofFile", required = false) MultipartFile proofFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Payment existingPayment = paymentService.getPaymentById(id);
        if (existingPayment == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thanh toán");
            return "redirect:/admin/payments";
        }

        payment.setPaymentId(id);

        if (bindingResult.hasErrors()) {
            payment.setProofImage(existingPayment.getProofImage());

            model.addAttribute("pageTitle", "Cập nhật thanh toán");
            model.addAttribute("activePage", "payments");
            model.addAttribute("payment", payment);
            model.addAttribute("isEdit", true);
            return "admin/payments/form";
        }

        try {
            paymentService.updatePaymentAdmin(id, payment, proofFile);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thanh toán thành công");
            return "redirect:/admin/payments";
        } catch (IllegalArgumentException ex) {
            payment.setProofImage(existingPayment.getProofImage());

            model.addAttribute("pageTitle", "Cập nhật thanh toán");
            model.addAttribute("activePage", "payments");
            model.addAttribute("payment", payment);
            model.addAttribute("isEdit", true);
            model.addAttribute("errorMessage", ex.getMessage());
            return "admin/payments/form";
        }
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        paymentService.approvePayment(id);
        redirectAttributes.addFlashAttribute("successMessage", "Duyệt thanh toán thành công");
        return "redirect:/admin/payments";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        paymentService.rejectPayment(id);
        redirectAttributes.addFlashAttribute("successMessage", "Từ chối thanh toán thành công");
        return "redirect:/admin/payments";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = paymentService.deletePayment(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Xóa thanh toán thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thanh toán");
        }

        return "redirect:/admin/payments";
    }
}