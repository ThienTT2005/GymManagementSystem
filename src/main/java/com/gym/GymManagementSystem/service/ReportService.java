package com.gym.GymManagementSystem.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface ReportService {
    long countTotalPayments();
    long countPendingPayments();
    BigDecimal getTotalRevenue();
    long countTrialRegistrations();
    List<Object[]> getMonthlyRevenue();
    List<Object[]> getTopPackages();
}