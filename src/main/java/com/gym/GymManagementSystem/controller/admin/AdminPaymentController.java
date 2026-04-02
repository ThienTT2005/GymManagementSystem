package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.Payment;
import com.gym.GymManagementSystem.service.PaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/payments")
public class AdminPaymentController {

    private final PaymentService paymentService;

    public AdminPaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @GetMapping
    public String listPayments(@RequestParam(value = "keyword", required = false) String keyword,
                               @RequestParam(value = "status", required = false) String status,
                               @RequestParam(value = "page", defaultValue = "0") int page,
                               @RequestParam(value = "size", defaultValue = "5") int size,
                               Model model) {

        var paymentPage = paymentService.searchPayments(keyword, status, page, size);

        model.addAttribute("pageTitle", "Thanh toán");
        model.addAttribute("paymentList", paymentPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", paymentPage.getTotalPages());
        model.addAttribute("size", size);

        return "admin/payments/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Payment payment = new Payment();
        payment.setPaymentDate(LocalDate.now());
        payment.setStatus("Chờ duyệt");

        model.addAttribute("pageTitle", "Thêm thanh toán");
        model.addAttribute("payment", payment);
        return "admin/payments/form";
    }

    @PostMapping("/save")
    public String savePayment(@ModelAttribute("payment") Payment payment) {
        if (payment.getPaymentDate() == null) {
            payment.setPaymentDate(LocalDate.now());
        }

        if (payment.getPaymentId() == null) {
            payment.setStatus("Chờ duyệt");
        } else {
            Payment oldPayment = paymentService.findById(payment.getPaymentId());
            if (oldPayment != null) {
                payment.setStatus(oldPayment.getStatus());
            } else {
                payment.setStatus("Chờ duyệt");
            }
        }

        paymentService.save(payment);
        return "redirect:/admin/payments";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Payment payment = paymentService.findById(id);
        model.addAttribute("pageTitle", "Sửa thanh toán");
        model.addAttribute("payment", payment);
        return "admin/payments/form";
    }

    @GetMapping("/delete/{id}")
    public String deletePayment(@PathVariable Long id) {
        paymentService.deleteById(id);
        return "redirect:/admin/payments";
    }

    @GetMapping("/approve/{id}")
    public String approvePayment(@PathVariable Long id) {
        paymentService.approvePayment(id);
        return "redirect:/admin/payments";
    }

    @GetMapping("/reject/{id}")
    public String rejectPayment(@PathVariable Long id) {
        paymentService.rejectPayment(id);
        return "redirect:/admin/payments";
    }
}