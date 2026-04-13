package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public PaymentService(PaymentRepository paymentRepository,
                          MembershipRepository membershipRepository,
                          ClassRegistrationRepository classRegistrationRepository) {
        this.paymentRepository = paymentRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
    }

    public Page<Payment> searchPayments(String keyword,
                                        String status,
                                        String paymentMethod,
                                        String fromDate,
                                        String toDate,
                                        int page,
                                        int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        String normalizedKeyword = trimToNull(keyword);
        String normalizedStatus = trimToNull(status);
        String normalizedPaymentMethod = trimToNull(paymentMethod);

        LocalDate from = parseDate(fromDate);
        LocalDate to = parseDate(toDate);

        PageRequest pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        return paymentRepository.searchAdminPayments(
                normalizedKeyword,
                normalizedStatus,
                normalizedPaymentMethod,
                from,
                to,
                pageable
        );
    }

    public Payment getPaymentById(Integer id) {
        return paymentRepository.findById(id).orElse(null);
    }

    public List<Membership> getAllMemberships() {
        return membershipRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"))
                .stream()
                .filter(item -> item.getMembershipId() != null)
                .filter(item -> "PENDING".equalsIgnoreCase(item.getStatus()))
                .toList();
    }

    public List<ClassRegistration> getAllClassRegistrations() {
        return classRegistrationRepository.findAll(Sort.by(Sort.Direction.DESC, "registrationDate"))
                .stream()
                .filter(item -> item.getRegistrationId() != null)
                .filter(item -> "PENDING".equalsIgnoreCase(item.getStatus()))
                .toList();
    }

    public Payment createPayment(Payment payment,
                                 Integer membershipId,
                                 Integer classRegistrationId,
                                 MultipartFile proofFile) {
        if (payment == null) {
            throw new IllegalArgumentException("Thông tin thanh toán không hợp lệ");
        }

        validateTarget(membershipId, classRegistrationId);
        bindTarget(payment, membershipId, classRegistrationId);

        if (payment.getMembership() == null && payment.getClassRegistration() == null) {
            throw new IllegalArgumentException("Không tìm thấy đối tượng thanh toán");
        }

        validateNoPaidPaymentExists(payment.getMembership(), payment.getClassRegistration());

        payment.setPaymentMethod(normalizePaymentMethod(payment.getPaymentMethod()));
        payment.setStatus(normalizeStatus(payment.getStatus(), "PENDING"));
        payment.setNote(trimToNull(payment.getNote()));
        payment.setProofImage(storeImage(proofFile, payment.getProofImage(), "payment-"));

        return paymentRepository.save(payment);
    }

    public Payment updatePayment(Integer id,
                                 Payment formPayment,
                                 Integer membershipId,
                                 Integer classRegistrationId,
                                 MultipartFile proofFile) {
        Optional<Payment> optional = paymentRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Payment existing = optional.get();

        validateTarget(membershipId, classRegistrationId);
        bindTarget(existing, membershipId, classRegistrationId);

        if (existing.getMembership() == null && existing.getClassRegistration() == null) {
            throw new IllegalArgumentException("Không tìm thấy đối tượng thanh toán");
        }

        existing.setAmount(formPayment.getAmount());
        existing.setPaymentMethod(normalizePaymentMethod(formPayment.getPaymentMethod()));
        existing.setPaymentDate(formPayment.getPaymentDate());
        existing.setStatus(normalizeStatus(formPayment.getStatus(), existing.getStatus()));
        existing.setNote(trimToNull(formPayment.getNote()));
        existing.setProofImage(storeImage(proofFile, existing.getProofImage(), "payment-"));

        return paymentRepository.save(existing);
    }

    public Payment updatePaymentAdmin(Integer id, Payment formPayment, MultipartFile proofFile) {
        Optional<Payment> optional = paymentRepository.findById(id);
        if (optional.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy thanh toán");
        }

        Payment existing = optional.get();

        existing.setStatus(normalizeStatus(formPayment.getStatus(), existing.getStatus()));
        existing.setNote(trimToNull(formPayment.getNote()));
        existing.setProofImage(storeImage(proofFile, existing.getProofImage(), "payment-"));

        return paymentRepository.save(existing);
    }

    public void approvePayment(Integer id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thanh toán"));

        payment.setStatus("PAID");
        paymentRepository.save(payment);
    }

    public void rejectPayment(Integer id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thanh toán"));

        payment.setStatus("REJECTED");
        paymentRepository.save(payment);
    }

    public boolean deletePayment(Integer id) {
        return softDeletePayment(id);
    }

    public boolean softDeletePayment(Integer id) {
        Optional<Payment> optional = paymentRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        Payment payment = optional.get();
        payment.setStatus("CANCELLED");
        paymentRepository.save(payment);
        return true;
    }

    public long countPendingPayments() {
        return paymentRepository.countByStatus("PENDING");
    }

    public long countPending() {
        return countPendingPayments();
    }

    public List<Payment> findPending() {
        return paymentRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public List<Payment> getByMember(Integer memberId) {
        if (memberId == null) {
            return List.of();
        }
        return paymentRepository.findByMemberId(memberId);
    }

    private void bindTarget(Payment payment, Integer membershipId, Integer classRegistrationId) {
        if (membershipId != null) {
            Membership membership = membershipRepository.findById(membershipId).orElse(null);
            payment.setMembership(membership);
            payment.setClassRegistration(null);
            return;
        }

        if (classRegistrationId != null) {
            ClassRegistration classRegistration = classRegistrationRepository.findById(classRegistrationId).orElse(null);
            payment.setClassRegistration(classRegistration);
            payment.setMembership(null);
            return;
        }

        payment.setMembership(null);
        payment.setClassRegistration(null);
    }

    private void validateTarget(Integer membershipId, Integer classRegistrationId) {
        boolean hasMembership = membershipId != null;
        boolean hasClassRegistration = classRegistrationId != null;

        if (!hasMembership && !hasClassRegistration) {
            throw new IllegalArgumentException("Vui lòng chọn membership hoặc class registration");
        }

        if (hasMembership && hasClassRegistration) {
            throw new IllegalArgumentException("Chỉ được chọn một loại thanh toán");
        }
    }

    private void validateNoPaidPaymentExists(Membership membership, ClassRegistration classRegistration) {
        List<Payment> payments = paymentRepository.findAll(Sort.by(Sort.Direction.DESC, "paymentId"));

        boolean hasPaid = payments.stream().anyMatch(p -> {
            if (!"PAID".equalsIgnoreCase(p.getStatus())) {
                return false;
            }

            if (membership != null && p.getMembership() != null) {
                return membership.getMembershipId() != null
                        && membership.getMembershipId().equals(p.getMembership().getMembershipId());
            }

            if (classRegistration != null && p.getClassRegistration() != null) {
                return classRegistration.getRegistrationId() != null
                        && classRegistration.getRegistrationId().equals(p.getClassRegistration().getRegistrationId());
            }

            return false;
        });

        if (hasPaid) {
            throw new IllegalArgumentException("Đối tượng này đã có thanh toán PAID");
        }
    }

    private String storeImage(MultipartFile file, String currentValue, String prefix) {
        if (file == null || file.isEmpty()) {
            return currentValue;
        }

        try {
            String original = file.getOriginalFilename();
            String ext = "";
            if (original != null && original.contains(".")) {
                ext = original.substring(original.lastIndexOf('.'));
            }

            String fileName = prefix + UUID.randomUUID() + ext;

            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);
            Files.copy(file.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);

            return fileName;
        } catch (IOException e) {
            throw new RuntimeException("Không thể lưu minh chứng thanh toán", e);
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private LocalDate parseDate(String value) {
        try {
            return trimToNull(value) == null ? null : LocalDate.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String normalizeStatus(String newStatus, String fallback) {
        String normalized = trimToNull(newStatus);
        if (normalized == null) {
            return fallback;
        }

        if ("PENDING".equalsIgnoreCase(normalized)) return "PENDING";
        if ("PAID".equalsIgnoreCase(normalized)) return "PAID";
        if ("REJECTED".equalsIgnoreCase(normalized)) return "REJECTED";
        if ("CANCELLED".equalsIgnoreCase(normalized)) return "CANCELLED";

        throw new IllegalArgumentException("Trạng thái thanh toán không hợp lệ");
    }

    private String normalizePaymentMethod(String paymentMethod) {
        String normalized = trimToNull(paymentMethod);
        if (normalized == null) {
            return "BANK_TRANSFER";
        }

        if ("BANK_TRANSFER".equalsIgnoreCase(normalized)) return "BANK_TRANSFER";
        if ("CASH".equalsIgnoreCase(normalized)) return "CASH";

        throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
    }
}