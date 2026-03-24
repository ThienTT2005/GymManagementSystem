package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.dto.MonthlyRevenueDTO;
import com.gym.GymManagementSystem.entity.Payment;
import org.springframework.data.domain.Page;

import java.util.List;

public interface PaymentService {
    List<Payment> findAll();
    Payment findById(Long id);
    Payment save(Payment payment);
    void deleteById(Long id);
    List<MonthlyRevenueDTO> getMonthlyRevenueComparison();
    void approvePayment(Long id);
    void rejectPayment(Long id);
    Page<Payment> searchPayments(String keyword, String status, int page, int size);
}