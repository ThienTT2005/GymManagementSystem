package com.gym.GymManagementSystem.dto;

import java.math.BigDecimal;

public class MonthlyRevenueDTO {
    private int month;
    private BigDecimal revenueCurrentYear;
    private BigDecimal revenuePreviousYear;
    private int heightCurrentYear;
    private int heightPreviousYear;

    public MonthlyRevenueDTO() {
    }

    public MonthlyRevenueDTO(int month, BigDecimal revenueCurrentYear, BigDecimal revenuePreviousYear) {
        this.month = month;
        this.revenueCurrentYear = revenueCurrentYear;
        this.revenuePreviousYear = revenuePreviousYear;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public BigDecimal getRevenueCurrentYear() {
        return revenueCurrentYear;
    }

    public void setRevenueCurrentYear(BigDecimal revenueCurrentYear) {
        this.revenueCurrentYear = revenueCurrentYear;
    }

    public BigDecimal getRevenuePreviousYear() {
        return revenuePreviousYear;
    }

    public void setRevenuePreviousYear(BigDecimal revenuePreviousYear) {
        this.revenuePreviousYear = revenuePreviousYear;
    }

    public int getHeightCurrentYear() {
        return heightCurrentYear;
    }

    public void setHeightCurrentYear(int heightCurrentYear) {
        this.heightCurrentYear = heightCurrentYear;
    }

    public int getHeightPreviousYear() {
        return heightPreviousYear;
    }

    public void setHeightPreviousYear(int heightPreviousYear) {
        this.heightPreviousYear = heightPreviousYear;
    }
}