package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConsultationService {

    private final ConsultationRepository consultationRepository;

    public ConsultationService(ConsultationRepository consultationRepository) {
        this.consultationRepository = consultationRepository;
    }

    public Page<Consultation> searchConsultations(String keyword, String status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        if (hasKeyword) {
            return consultationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            keyword.trim(), keyword.trim(), keyword.trim(), pageable
                    );
        }

        if (hasStatus) {
            return consultationRepository.findByStatus(status.trim(), pageable);
        }

        return consultationRepository.findAll(pageable);
    }

    public long countPending() {
        return consultationRepository.countByStatus("PENDING");
    }

    public List<Consultation> findPending() {
        return consultationRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public Consultation createConsultation(Consultation consultation) {
        if (consultation.getStatus() == null || consultation.getStatus().isBlank()) {
            consultation.setStatus("PENDING");
        }
        return consultationRepository.save(consultation);
    }

    public Consultation getConsultationById(Integer id) {
        return consultationRepository.findById(id).orElse(null);
    }

    public Consultation updateConsultation(Integer id, Consultation formConsultation) {
        return consultationRepository.findById(id).map(existing -> {
            existing.setFullname(formConsultation.getFullname());
            existing.setPhone(formConsultation.getPhone());
            existing.setEmail(formConsultation.getEmail());
            existing.setMessage(formConsultation.getMessage());
            existing.setStatus(formConsultation.getStatus());
            return consultationRepository.save(existing);
        }).orElse(null);
    }

    public boolean cancelConsultation(Integer id) {
        return consultationRepository.findById(id).map(existing -> {
            existing.setStatus("CANCELLED");
            consultationRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public void updateStatus(Integer id, String status) {
        consultationRepository.findById(id).ifPresent(c -> {
            c.setStatus(status);
            consultationRepository.save(c);
        });
    }
}