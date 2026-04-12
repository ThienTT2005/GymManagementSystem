package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.Payment;
import com.gym.GymManagementSystem.entity.TrialRegistration;
import com.gym.GymManagementSystem.repository.ClubRepository;
import com.gym.GymManagementSystem.repository.GymServiceRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import com.gym.GymManagementSystem.service.DashboardService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final MembershipRepository membershipRepository;
    private final PaymentRepository paymentRepository;
    private final GymServiceRepository gymServiceRepository;
    private final ClubRepository clubRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;

    public DashboardServiceImpl(MembershipRepository membershipRepository,
                                PaymentRepository paymentRepository,
                                GymServiceRepository gymServiceRepository,
                                ClubRepository clubRepository,
                                TrialRegistrationRepository trialRegistrationRepository) {
        this.membershipRepository = membershipRepository;
        this.paymentRepository = paymentRepository;
        this.gymServiceRepository = gymServiceRepository;
        this.clubRepository = clubRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
    }

    @Override
    public long getTotalMembers() {
        return membershipRepository.count();
    }

    @Override
    public long getActivePackages() {
        return membershipRepository.countByStatus("Đang hoạt động");
    }

    @Override
    public long getPendingPayments() {
        return paymentRepository.countByStatus("Chờ duyệt");
    }

    @Override
    public long getTotalServices() {
        return gymServiceRepository.count();
    }

    @Override
    public long getTotalBranches() {
        return clubRepository.count();
    }

    @Override
    public List<Payment> getPendingPaymentList() {
        return paymentRepository.findTop5ByStatusOrderByPaymentDateDesc("Chờ duyệt");
    }

    @Override
    public List<TrialRegistration> getPendingTrialList() {
        return trialRegistrationRepository.findTop5ByStatusOrderByRegisterDateDesc("Chờ liên hệ");
    }
}
