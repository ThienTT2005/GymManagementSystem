package com.gym.GymManagementSystem.dto;

public class DashboardTopPackageItem {

    private final String packageName;
    private final long totalRegistrations;

    public DashboardTopPackageItem(String packageName, long totalRegistrations) {
        this.packageName = packageName;
        this.totalRegistrations = totalRegistrations;
    }

    public String getPackageName() {
        return packageName;
    }

    public long getTotalRegistrations() {
        return totalRegistrations;
    }
}