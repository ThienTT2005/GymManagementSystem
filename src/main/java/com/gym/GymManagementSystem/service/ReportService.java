package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReportService {

    private final PaymentRepository paymentRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;
    private final MemberRepository memberRepository;
    private final ConsultationRepository consultationRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;

    public ReportService(PaymentRepository paymentRepository,
                         TrialRegistrationRepository trialRegistrationRepository,
                         MemberRepository memberRepository,
                         ConsultationRepository consultationRepository,
                         MembershipRepository membershipRepository,
                         ClassRegistrationRepository classRegistrationRepository) {
        this.paymentRepository = paymentRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
        this.memberRepository = memberRepository;
        this.consultationRepository = consultationRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
    }

    public long countTotalPayments() {
        return paymentRepository.count();
    }

    public long countPendingPayments() {
        return paymentRepository.countByStatus("PENDING");
    }

    public BigDecimal getTotalRevenue() {
        BigDecimal total = paymentRepository.sumPaidRevenue();
        return total != null ? total : BigDecimal.ZERO;
    }

    public long countMembers() {
        return memberRepository.count();
    }

    public long countTrialRegistrations() {
        return trialRegistrationRepository.count();
    }

    public long countContacts() {
        return consultationRepository.count();
    }

    public List<RevenueRow> getMonthlyRevenueRows(int limit) {
        List<RevenueRow> rows = new ArrayList<>();
        List<Object[]> monthlyRevenue = paymentRepository.getMonthlyRevenue();

        if (monthlyRevenue != null) {
            for (Object[] row : monthlyRevenue) {
                String month = row[0] != null ? String.valueOf(row[0]) : "-";
                BigDecimal revenue = toBigDecimal(row.length > 1 ? row[1] : null);
                rows.add(new RevenueRow(month, revenue));
            }
        }

        rows.sort(Comparator.comparing(RevenueRow::getMonth).reversed());
        return applyLimit(rows, limit);
    }

    public List<PackageRevenueRow> getPackageRevenueRows(int limit) {
        Map<String, PackageRevenueRow> packageMap = new LinkedHashMap<>();
        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        for (Payment payment : payments) {
            if (!"PAID".equalsIgnoreCase(payment.getStatus()) || payment.getMembership() == null) {
                continue;
            }

            Membership membership = payment.getMembership();
            String packageName = membership.getGymPackage() != null
                    ? membership.getGymPackage().getPackageName()
                    : "Chưa xác định";

            PackageRevenueRow row = packageMap.computeIfAbsent(packageName, key -> new PackageRevenueRow(key));
            row.setRevenue(row.getRevenue().add(toBigDecimal(payment.getAmount())));
            row.setPaymentCount(row.getPaymentCount() + 1);
        }

        List<PackageRevenueRow> rows = new ArrayList<>(packageMap.values());
        rows.sort(Comparator.comparing(PackageRevenueRow::getRevenue).reversed());
        return applyLimit(rows, limit);
    }

    public List<ServiceRevenueRow> getServiceRevenueRows(int limit) {
        Map<String, ServiceRevenueRow> serviceMap = new LinkedHashMap<>();
        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        for (Payment payment : payments) {
            if (!"PAID".equalsIgnoreCase(payment.getStatus()) || payment.getClassRegistration() == null) {
                continue;
            }

            ClassRegistration registration = payment.getClassRegistration();
            String serviceName = registration.getService() != null
                    ? registration.getService().getServiceName()
                    : "Chưa xác định";

            ServiceRevenueRow row = serviceMap.computeIfAbsent(serviceName, key -> new ServiceRevenueRow(key));
            row.setRevenue(row.getRevenue().add(toBigDecimal(payment.getAmount())));
            row.setPaymentCount(row.getPaymentCount() + 1);
        }

        List<ServiceRevenueRow> rows = new ArrayList<>(serviceMap.values());
        rows.sort(Comparator.comparing(ServiceRevenueRow::getRevenue).reversed());
        return applyLimit(rows, limit);
    }

    public List<LoyalMemberRow> getLoyalMemberRows(int limit) {
        Map<Integer, LoyalMemberRow> memberMap = new LinkedHashMap<>();
        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        for (Payment payment : payments) {
            if (!"PAID".equalsIgnoreCase(payment.getStatus())) {
                continue;
            }

            Member member = extractMemberFromPayment(payment);
            if (member == null || member.getMemberId() == null) {
                continue;
            }

            LoyalMemberRow row = memberMap.computeIfAbsent(member.getMemberId(),
                    key -> new LoyalMemberRow(
                            member.getMemberId(),
                            member.getFullname(),
                            member.getPhone()
                    ));

            row.setTotalSpent(row.getTotalSpent().add(toBigDecimal(payment.getAmount())));
            row.setPaymentCount(row.getPaymentCount() + 1);
        }

        List<LoyalMemberRow> rows = new ArrayList<>(memberMap.values());
        rows.sort(Comparator
                .comparing(LoyalMemberRow::getTotalSpent).reversed()
                .thenComparing(LoyalMemberRow::getPaymentCount, Comparator.reverseOrder()));
        return applyLimit(rows, limit);
    }

    private Member extractMemberFromPayment(Payment payment) {
        if (payment.getMembership() != null && payment.getMembership().getMember() != null) {
            return payment.getMembership().getMember();
        }

        if (payment.getClassRegistration() != null && payment.getClassRegistration().getMember() != null) {
            return payment.getClassRegistration().getMember();
        }

        return null;
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal bigDecimal) {
            return bigDecimal;
        }
        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue());
        }
        try {
            return new BigDecimal(String.valueOf(value));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private <T> List<T> applyLimit(List<T> rows, int limit) {
        if (limit <= 0 || rows.size() <= limit) {
            return rows;
        }
        return rows.subList(0, limit);
    }

    public static class RevenueRow {
        private final String month;
        private final BigDecimal revenue;

        public RevenueRow(String month, BigDecimal revenue) {
            this.month = month;
            this.revenue = revenue;
        }

        public String getMonth() {
            return month;
        }

        public BigDecimal getRevenue() {
            return revenue;
        }
    }

    public static class PackageRevenueRow {
        private final String packageName;
        private BigDecimal revenue = BigDecimal.ZERO;
        private int paymentCount = 0;

        public PackageRevenueRow(String packageName) {
            this.packageName = packageName;
        }

        public String getPackageName() {
            return packageName;
        }

        public BigDecimal getRevenue() {
            return revenue;
        }

        public void setRevenue(BigDecimal revenue) {
            this.revenue = revenue;
        }

        public int getPaymentCount() {
            return paymentCount;
        }

        public void setPaymentCount(int paymentCount) {
            this.paymentCount = paymentCount;
        }
    }

    public static class ServiceRevenueRow {
        private final String serviceName;
        private BigDecimal revenue = BigDecimal.ZERO;
        private int paymentCount = 0;

        public ServiceRevenueRow(String serviceName) {
            this.serviceName = serviceName;
        }

        public String getServiceName() {
            return serviceName;
        }

        public BigDecimal getRevenue() {
            return revenue;
        }

        public void setRevenue(BigDecimal revenue) {
            this.revenue = revenue;
        }

        public int getPaymentCount() {
            return paymentCount;
        }

        public void setPaymentCount(int paymentCount) {
            this.paymentCount = paymentCount;
        }
    }

    public static class LoyalMemberRow {
        private final Integer memberId;
        private final String fullName;
        private final String phone;
        private BigDecimal totalSpent = BigDecimal.ZERO;
        private int paymentCount = 0;

        public LoyalMemberRow(Integer memberId, String fullName, String phone) {
            this.memberId = memberId;
            this.fullName = fullName;
            this.phone = phone;
        }

        public Integer getMemberId() {
            return memberId;
        }

        public String getFullName() {
            return fullName;
        }

        public String getPhone() {
            return phone;
        }

        public BigDecimal getTotalSpent() {
            return totalSpent;
        }

        public void setTotalSpent(BigDecimal totalSpent) {
            this.totalSpent = totalSpent;
        }

        public int getPaymentCount() {
            return paymentCount;
        }

        public void setPaymentCount(int paymentCount) {
            this.paymentCount = paymentCount;
        }
    }
}