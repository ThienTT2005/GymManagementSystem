package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PackageRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.TrainerRepository;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Service
public class DashboardService {

    private final MemberRepository memberRepository;
    private final StaffRepository staffRepository;
    private final TrainerRepository trainerRepository;
    private final GymClassRepository gymClassRepository;
    private final PackageRepository packageRepository;
    private final PaymentRepository paymentRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;
    private final ConsultationRepository consultationRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;

    public DashboardService(MemberRepository memberRepository,
                            StaffRepository staffRepository,
                            TrainerRepository trainerRepository,
                            GymClassRepository gymClassRepository,
                            PackageRepository packageRepository,
                            PaymentRepository paymentRepository,
                            TrialRegistrationRepository trialRegistrationRepository,
                            ConsultationRepository consultationRepository,
                            MembershipRepository membershipRepository,
                            ClassRegistrationRepository classRegistrationRepository) {
        this.memberRepository = memberRepository;
        this.staffRepository = staffRepository;
        this.trainerRepository = trainerRepository;
        this.gymClassRepository = gymClassRepository;
        this.packageRepository = packageRepository;
        this.paymentRepository = paymentRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
        this.consultationRepository = consultationRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
    }

    public long countMembers() {
        return memberRepository.count();
    }

    public long countStaff() {
        return staffRepository.count();
    }

    public long countTrainers() {
        return trainerRepository.count();
    }

    public long countClasses() {
        return gymClassRepository.count();
    }

    public long countPackages() {
        return packageRepository.count();
    }

    public long countTrials() {
        return trialRegistrationRepository.count();
    }

    public long countConsultations() {
        return consultationRepository.count();
    }

    public long countPendingMemberships() {
        return membershipRepository.countByStatus("PENDING");
    }

    public long countPendingClassRegistrations() {
        return classRegistrationRepository.countByStatus("PENDING");
    }

    public long countPendingPayments() {
        return paymentRepository.countByStatus("PENDING");
    }

    public long countPendingTrials() {
        return trialRegistrationRepository.countByStatus("PENDING");
    }

    public long countPendingConsultations() {
        return consultationRepository.countByStatus("NEW");
    }

    public BigDecimal getTotalRevenue() {
        BigDecimal total = paymentRepository.sumPaidRevenue();
        return total != null ? total : BigDecimal.ZERO;
    }

    public List<Object[]> getMonthlyRevenue() {
        try {
            List<Object[]> data = paymentRepository.getMonthlyRevenue();
            return data != null ? data : Collections.emptyList();
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    public long countPaidPayments() {
        return paymentRepository.countByStatus("PAID");
    }

    public long countRejectedPayments() {
        return paymentRepository.countByStatus("REJECTED");
    }

    public long countCancelledPayments() {
        return paymentRepository.countByStatus("CANCELLED");
    }
}