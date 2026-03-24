package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.dto.MonthlyRevenueDTO;
import com.gym.GymManagementSystem.entity.Payment;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.service.PaymentService;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;

@Service
public class PaymentServiceImpl implements PaymentService {

    private final PaymentRepository paymentRepository;

    public PaymentServiceImpl(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    @Override
    public List<Payment> findAll() {
        return paymentRepository.findAll();
    }

    @Override
    public Payment findById(Long id) {
        return paymentRepository.findById(id).orElse(null);
    }

    @Override
    public Payment save(Payment payment) {
        return paymentRepository.save(payment);
    }

    @Override
    public void deleteById(Long id) {
        paymentRepository.deleteById(id);
    }

    @Override
    public List<MonthlyRevenueDTO> getMonthlyRevenueComparison() {
        int currentYear = Year.now().getValue();
        int previousYear = currentYear - 1;
        int currentMonth = java.time.LocalDate.now().getMonthValue();

        List<Object[]> rawData = paymentRepository.getMonthlyRevenueComparison(currentYear, previousYear);

        BigDecimal[] currentYearData = new BigDecimal[13];
        BigDecimal[] previousYearData = new BigDecimal[13];

        for (int i = 1; i <= 12; i++) {
            currentYearData[i] = BigDecimal.ZERO;
            previousYearData[i] = BigDecimal.ZERO;
        }

        for (Object[] row : rawData) {
            int month = ((Number) row[0]).intValue();

            BigDecimal currentRevenue = row[1] != null
                    ? new BigDecimal(row[1].toString())
                    : BigDecimal.ZERO;

            BigDecimal previousRevenue = row[2] != null
                    ? new BigDecimal(row[2].toString())
                    : BigDecimal.ZERO;

            currentYearData[month] = currentRevenue;
            previousYearData[month] = previousRevenue;
        }

        BigDecimal maxRevenue = BigDecimal.ONE;

        for (int month = 1; month <= currentMonth; month++) {
            if (currentYearData[month].compareTo(maxRevenue) > 0) {
                maxRevenue = currentYearData[month];
            }
            if (previousYearData[month].compareTo(maxRevenue) > 0) {
                maxRevenue = previousYearData[month];
            }
        }

        List<MonthlyRevenueDTO> result = new ArrayList<>();

        for (int month = 1; month <= currentMonth; month++) {
            MonthlyRevenueDTO dto = new MonthlyRevenueDTO(
                    month,
                    currentYearData[month],
                    previousYearData[month]
            );

            int currentHeight = currentYearData[month]
                    .multiply(BigDecimal.valueOf(180))
                    .divide(maxRevenue, 0, RoundingMode.HALF_UP)
                    .intValue();

            int previousHeight = previousYearData[month]
                    .multiply(BigDecimal.valueOf(180))
                    .divide(maxRevenue, 0, RoundingMode.HALF_UP)
                    .intValue();

            dto.setHeightCurrentYear(currentHeight);
            dto.setHeightPreviousYear(previousHeight);

            result.add(dto);
        }

        return result;
    }
    @Override
    public void approvePayment(Long id) {
        Payment payment = paymentRepository.findById(id).orElse(null);
        if (payment != null) {
            payment.setStatus("Đã duyệt");
            paymentRepository.save(payment);
        }
    }

    @Override
    public void rejectPayment(Long id) {
        Payment payment = paymentRepository.findById(id).orElse(null);
        if (payment != null) {
            payment.setStatus("Từ chối");
            paymentRepository.save(payment);
        }
    }

    @Override
    public Page<Payment> searchPayments(String keyword, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("paymentDate").descending());
        return paymentRepository.searchPayments(keyword, status, pageable);
    }
}