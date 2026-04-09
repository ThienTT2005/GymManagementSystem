package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TrialRegistrationService {

    private final TrialRegistrationRepository trialRegistrationRepository;

    public TrialRegistrationService(TrialRegistrationRepository trialRegistrationRepository) {
        this.trialRegistrationRepository = trialRegistrationRepository;
    }

    public Page<TrialRegistration> searchTrials(String keyword, String status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        if (hasKeyword) {
            return trialRegistrationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            keyword.trim(), keyword.trim(), keyword.trim(), pageable
                    );
        }

        if (hasStatus) {
            return trialRegistrationRepository.findByStatus(status.trim(), pageable);
        }

        return trialRegistrationRepository.findAll(pageable);
    }

    public long countPending() {
        return trialRegistrationRepository.countByStatus("PENDING");
    }

    public List<TrialRegistration> findPending() {
        return trialRegistrationRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public TrialRegistration createTrial(TrialRegistration trial) {
        if (trial.getStatus() == null || trial.getStatus().isBlank()) {
            trial.setStatus("PENDING");
        }
        return trialRegistrationRepository.save(trial);
    }

    public TrialRegistration getTrialById(Integer id) {
        return trialRegistrationRepository.findById(id).orElse(null);
    }

    public TrialRegistration updateTrial(Integer id, TrialRegistration formTrial) {
        return trialRegistrationRepository.findById(id).map(existing -> {
            existing.setFullname(formTrial.getFullname());
            existing.setPhone(formTrial.getPhone());
            existing.setEmail(formTrial.getEmail());
            existing.setPreferredDate(formTrial.getPreferredDate());
            existing.setStatus(formTrial.getStatus());
            existing.setNote(formTrial.getNote());
            return trialRegistrationRepository.save(existing);
        }).orElse(null);
    }

    public boolean cancelTrial(Integer id) {
        return trialRegistrationRepository.findById(id).map(existing -> {
            existing.setStatus("CANCELLED");
            trialRegistrationRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public void updateStatus(Integer id, String status) {
        trialRegistrationRepository.findById(id).ifPresent(t -> {
            t.setStatus(status);
            trialRegistrationRepository.save(t);
        });
    }
}