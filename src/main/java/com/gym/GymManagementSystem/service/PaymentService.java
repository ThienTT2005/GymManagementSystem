package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.Membership;
import com.gym.GymManagementSystem.model.Payment;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.repository.PaymentRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final MembershipRepository membershipRepository;
    private final ClassRegistrationRepository classRegistrationRepository;

    public PaymentService(PaymentRepository paymentRepository,
                          MembershipRepository membershipRepository,
                          ClassRegistrationRepository classRegistrationRepository) {
        this.paymentRepository = paymentRepository;
        this.membershipRepository = membershipRepository;
        this.classRegistrationRepository = classRegistrationRepository;
    }

    public Page<Payment> searchPayments(String keyword, String status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "paymentId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        if (hasKeyword && hasStatus) {
            return paymentRepository.searchByKeywordAndStatus(keyword.trim(), status.trim(), pageable);
        }

        if (hasKeyword) {
            return paymentRepository.searchByKeyword(keyword.trim(), pageable);
        }

        if (hasStatus) {
            return paymentRepository.findByStatus(status.trim(), pageable);
        }

        return paymentRepository.findAll(pageable);
    }

    public Payment getPaymentById(Integer id) {
        return paymentRepository.findById(id).orElse(null);
    }

    public List<Membership> getAllMemberships() {
        return membershipRepository.findAll(Sort.by(Sort.Direction.DESC, "membershipId"));
    }

    public List<ClassRegistration> getAllClassRegistrations() {
        return classRegistrationRepository.findAll(Sort.by(Sort.Direction.DESC, "registrationId"));
    }

    public Payment createPayment(Payment payment, Integer membershipId, Integer classRegistrationId, MultipartFile proofFile) {
        bindTarget(payment, membershipId, classRegistrationId);
        payment.setProofImage(storeImage(proofFile, payment.getProofImage()));

        if (payment.getStatus() == null || payment.getStatus().isBlank()) {
            payment.setStatus("PENDING");
        }

        return paymentRepository.save(payment);
    }

    public Payment updatePayment(Integer id, Payment formPayment, Integer membershipId, Integer classRegistrationId, MultipartFile proofFile) {
        Optional<Payment> optional = paymentRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Payment existing = optional.get();
        existing.setAmount(formPayment.getAmount());
        existing.setPaymentMethod(formPayment.getPaymentMethod());
        existing.setPaymentDate(formPayment.getPaymentDate());
        existing.setStatus(formPayment.getStatus());
        existing.setNote(formPayment.getNote());
        existing.setProofImage(storeImage(proofFile, existing.getProofImage()));

        bindTarget(existing, membershipId, classRegistrationId);
        return paymentRepository.save(existing);
    }

    public void approvePayment(Integer id) {
        paymentRepository.findById(id).ifPresent(p -> {
            p.setStatus("PAID");
            paymentRepository.save(p);
        });
    }

    public void rejectPayment(Integer id) {
        paymentRepository.findById(id).ifPresent(p -> {
            p.setStatus("REJECTED");
            paymentRepository.save(p);
        });
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

    private String storeImage(MultipartFile file, String currentValue) {
        if (file == null || file.isEmpty()) {
            return currentValue;
        }

        String original = file.getOriginalFilename();
        String ext = "";
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }

        return "payment-" + UUID.randomUUID() + ext;
    }
}