package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.Payment;
import com.gym.GymManagementSystem.entity.TrialRegistration;

import java.util.List;

public interface DashboardService {

    long getTotalMembers();

    long getActivePackages();

    long getPendingPayments();

    long getTotalServices();

    long getTotalBranches();

    List<Payment> getPendingPaymentList();

    List<TrialRegistration> getPendingTrialList();
}