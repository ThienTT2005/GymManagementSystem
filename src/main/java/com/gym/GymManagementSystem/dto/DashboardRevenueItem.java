package com.gym.GymManagementSystem.dto;

import java.math.BigDecimal;

public class DashboardRevenueItem {
    private String monthLabel;
    private BigDecimal totalRevenue;

    public DashboardRevenueItem(String monthLabel, BigDecimal totalRevenue) {
        this.monthLabel = monthLabel;
        this.totalRevenue = totalRevenue;
    }

    public String getMonthLabel() {
        return monthLabel;
    }

    public void setMonthLabel(String monthLabel) {
        this.monthLabel = monthLabel;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}