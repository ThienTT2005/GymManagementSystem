package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConsultationService {

    private final ConsultationRepository consultationRepository;

    public ConsultationService(ConsultationRepository consultationRepository) {
        this.consultationRepository = consultationRepository;
    }

    public Page<Consultation> searchContacts(String keyword, String status, int page, int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        String normalizedKeyword = trimToNull(keyword);
        String normalizedStatus = trimToNull(status);

        PageRequest pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "consultationId")
        );

        boolean hasKeyword = normalizedKeyword != null;
        boolean hasStatus = normalizedStatus != null;

        if (hasKeyword && hasStatus) {
            return consultationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedStatus,
                            pageable
                    );
        }

        if (hasKeyword) {
            return consultationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedKeyword,
                            pageable
                    );
        }

        if (hasStatus) {
            return consultationRepository.findByStatus(normalizedStatus, pageable);
        }

        return consultationRepository.findAll(pageable);
    }

    public long countPending() {
        return consultationRepository.countByStatus("NEW");
    }

    public List<Consultation> findPending() {
        return consultationRepository.findByStatus("NEW", PageRequest.of(0, 5)).getContent();
    }

    public Consultation createContact(Consultation consultation) {
        if (consultation == null) {
            throw new IllegalArgumentException("Thông tin tư vấn không hợp lệ");
        }

        normalizeContact(consultation);

        if (consultation.getStatus() == null || consultation.getStatus().isBlank()) {
            consultation.setStatus("NEW");
        } else {
            consultation.setStatus(normalizeStatus(consultation.getStatus()));
        }

        return consultationRepository.save(consultation);
    }

    public Consultation getContactById(Integer id) {
        if (id == null) {
            return null;
        }
        return consultationRepository.findById(id).orElse(null);
    }

    public Consultation updateContact(Integer id, Consultation formContact) {
        if (id == null || formContact == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }

        return consultationRepository.findById(id).map(existing -> {
            normalizeContact(formContact);

            existing.setFullname(formContact.getFullname());
            existing.setPhone(formContact.getPhone());
            existing.setEmail(formContact.getEmail());
            existing.setMessage(formContact.getMessage());
            existing.setStatus(normalizeStatus(formContact.getStatus()));

            return consultationRepository.save(existing);
        }).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy yêu cầu tư vấn"));
    }

    public boolean deleteContact(Integer id) {
        return consultationRepository.findById(id).map(existing -> {
            existing.setStatus("CONTACTED");
            consultationRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public void updateStatus(Integer id, String status) {
        Consultation existing = consultationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy yêu cầu tư vấn"));

        existing.setStatus(normalizeStatus(status));
        consultationRepository.save(existing);
    }

    private void normalizeContact(Consultation consultation) {
        consultation.setFullname(trimToNull(consultation.getFullname()));
        consultation.setPhone(trimToNull(consultation.getPhone()));
        consultation.setEmail(trimToNull(consultation.getEmail()));
        consultation.setMessage(trimToNull(consultation.getMessage()));
    }

    private String normalizeStatus(String status) {
        String normalized = trimToNull(status);
        if (normalized == null) {
            return "NEW";
        }

        if ("NEW".equalsIgnoreCase(normalized)) return "NEW";
        if ("CONTACTED".equalsIgnoreCase(normalized)) return "CONTACTED";

        throw new IllegalArgumentException("Trạng thái tư vấn không hợp lệ");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}