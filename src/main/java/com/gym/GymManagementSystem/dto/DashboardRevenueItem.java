package com.gym.GymManagementSystem.dto;

import java.math.BigDecimal;

public class DashboardRevenueItem {

    private final String monthLabel;
    private final BigDecimal totalRevenue;

    public DashboardRevenueItem(String monthLabel, BigDecimal totalRevenue) {
        this.monthLabel = monthLabel;
        this.totalRevenue = totalRevenue;
    }

    public String getMonthLabel() {
        return monthLabel;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
}