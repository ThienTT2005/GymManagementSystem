package com.gym.GymManagementSystem.dto;

public class DashboardTopPackageItem {
    private String packageName;
    private long totalRegistrations;

    public DashboardTopPackageItem(String packageName, long totalRegistrations) {
        this.packageName = packageName;
        this.totalRegistrations = totalRegistrations;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public long getTotalRegistrations() {
        return totalRegistrations;
    }

    public void setTotalRegistrations(long totalRegistrations) {
        this.totalRegistrations = totalRegistrations;
    }
}