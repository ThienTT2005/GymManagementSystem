package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.dto.DashboardRevenueItem;
import com.gym.GymManagementSystem.dto.DashboardTopPackageItem;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.repository.*;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class DashboardService {

    private final MemberRepository memberRepository;
    private final StaffRepository staffRepository;
    private final GymClassRepository gymClassRepository;
    private final PackageRepository packageRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;
    private final PaymentRepository paymentRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;
    private final ConsultationRepository consultationRepository;

    public DashboardService(MemberRepository memberRepository,
                            StaffRepository staffRepository,
                            GymClassRepository gymClassRepository,
                            PackageRepository packageRepository,
                            MembershipRepository membershipRepository,
                            ClassRegistrationRepository classRegistrationRepository,
                            PaymentRepository paymentRepository,
                            TrialRegistrationRepository trialRegistrationRepository,
                            ConsultationRepository consultationRepository) {
        this.memberRepository = memberRepository;
        this.staffRepository = staffRepository;
        this.gymClassRepository = gymClassRepository;
        this.packageRepository = packageRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
        this.paymentRepository = paymentRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
        this.consultationRepository = consultationRepository;
    }

    public long countMembers() {
        return memberRepository.count();
    }

    public long countStaff() {
        return staffRepository.count();
    }

    public long countClasses() {
        return gymClassRepository.count();
    }

    public long countPackages() {
        return packageRepository.count();
    }

    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = paymentRepository.getTotalRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    public long countPendingMemberships() {
        return membershipRepository.countByStatus("PENDING");
    }

    public long countPendingServiceRegistrations() {
        return classRegistrationRepository.countByStatus("PENDING");
    }

    public long countPendingPayments() {
        return paymentRepository.countByStatus("PENDING");
    }

    public long countPendingTrials() {
        return trialRegistrationRepository.countByStatus("PENDING");
    }

    public long countPendingConsultations() {
        return consultationRepository.countByStatus("PENDING");
    }

    public List<GymClass> getTopClasses() {
        return gymClassRepository.findByStatusOrderByCurrentMemberDesc(1, PageRequest.of(0, 5));
    }

    public List<DashboardTopPackageItem> getTopPackages() {
        return membershipRepository.findTopPackages(PageRequest.of(0, 5));
    }

    public List<DashboardRevenueItem> getMonthlyRevenue() {
        List<Object[]> rows = paymentRepository.getMonthlyRevenue();
        List<DashboardRevenueItem> items = new ArrayList<>();

        for (Object[] row : rows) {
            String monthLabel = row[0] != null ? row[0].toString() : "";
            BigDecimal totalRevenue;

            if (row[1] instanceof BigDecimal value) {
                totalRevenue = value;
            } else if (row[1] != null) {
                totalRevenue = new BigDecimal(row[1].toString());
            } else {
                totalRevenue = BigDecimal.ZERO;
            }

            items.add(new DashboardRevenueItem(monthLabel, totalRevenue));
        }

        return items;
    }
}