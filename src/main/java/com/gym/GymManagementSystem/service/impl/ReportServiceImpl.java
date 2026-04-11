package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import com.gym.GymManagementSystem.service.ReportService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ReportServiceImpl implements ReportService {

    private final PaymentRepository paymentRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;

    public ReportServiceImpl(PaymentRepository paymentRepository, 
                             TrialRegistrationRepository trialRegistrationRepository) {
        this.paymentRepository = paymentRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
    }

    @Override
    public long countTotalPayments() {
        return paymentRepository.count();
    }

    @Override
    public long countPendingPayments() {
        return paymentRepository.countByStatus("Chờ xử lý");
    }

    @Override
    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = paymentRepository.getTotalRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    @Override
    public long countTrialRegistrations() {
        return trialRegistrationRepository.count();
    }

    @Override
    public List<Object[]> getMonthlyRevenue() {
        return paymentRepository.getMonthlyRevenue();
    }

    @Override
    public List<Object[]> getTopPackages() {
        return paymentRepository.getTopPackages();
    }
}
