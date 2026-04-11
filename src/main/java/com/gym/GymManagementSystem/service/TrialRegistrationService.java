package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class TrialRegistrationService {

    private final TrialRegistrationRepository trialRegistrationRepository;

    public TrialRegistrationService(TrialRegistrationRepository trialRegistrationRepository) {
        this.trialRegistrationRepository = trialRegistrationRepository;
    }

    public Page<TrialRegistration> searchTrials(String keyword,
                                                String status,
                                                String preferredDate,
                                                int page,
                                                int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        String normalizedKeyword = trimToNull(keyword);
        String normalizedStatus = trimToNull(status);
        LocalDate normalizedPreferredDate = parseDate(preferredDate);

        PageRequest pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "trialId")
        );

        Page<TrialRegistration> basePage;
        boolean hasKeyword = normalizedKeyword != null;
        boolean hasStatus = normalizedStatus != null;

        if (hasKeyword && hasStatus) {
            basePage = trialRegistrationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedStatus,
                            pageable
                    );
        } else if (hasKeyword) {
            basePage = trialRegistrationRepository
                    .findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            normalizedKeyword,
                            normalizedKeyword,
                            normalizedKeyword,
                            pageable
                    );
        } else if (hasStatus) {
            basePage = trialRegistrationRepository.findByStatus(normalizedStatus, pageable);
        } else {
            basePage = trialRegistrationRepository.findAll(pageable);
        }

        if (normalizedPreferredDate == null) {
            return basePage;
        }

        List<TrialRegistration> filtered = basePage.getContent().stream()
                .filter(item -> normalizedPreferredDate.equals(item.getPreferredDate()))
                .toList();

        return new PageImpl<>(filtered, pageable, filtered.size());
    }

    public long countPending() {
        return trialRegistrationRepository.countByStatus("PENDING");
    }

    public List<TrialRegistration> findPending() {
        return trialRegistrationRepository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public TrialRegistration createTrial(TrialRegistration trial) {
        if (trial == null) {
            throw new IllegalArgumentException("Thông tin đăng ký tập thử không hợp lệ");
        }

        normalizeTrial(trial);

        if (trial.getStatus() == null || trial.getStatus().isBlank()) {
            trial.setStatus("PENDING");
        } else {
            trial.setStatus(normalizeStatus(trial.getStatus()));
        }

        return trialRegistrationRepository.save(trial);
    }

    public TrialRegistration getTrialById(Integer id) {
        if (id == null) {
            return null;
        }
        return trialRegistrationRepository.findById(id).orElse(null);
    }

    public TrialRegistration updateTrial(Integer id, TrialRegistration formTrial) {
        if (id == null || formTrial == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }

        return trialRegistrationRepository.findById(id).map(existing -> {
            normalizeTrial(formTrial);

            existing.setFullname(formTrial.getFullname());
            existing.setPhone(formTrial.getPhone());
            existing.setEmail(formTrial.getEmail());
            existing.setPreferredDate(formTrial.getPreferredDate());
            existing.setStatus(normalizeStatus(formTrial.getStatus()));
            existing.setNote(formTrial.getNote());

            return trialRegistrationRepository.save(existing);
        }).orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký tập thử"));
    }

    public boolean deleteTrial(Integer id) {
        return cancelTrial(id);
    }

    public boolean cancelTrial(Integer id) {
        return trialRegistrationRepository.findById(id).map(existing -> {
            existing.setStatus("CANCELLED");
            trialRegistrationRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public void updateStatus(Integer id, String status) {
        TrialRegistration existing = trialRegistrationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đăng ký tập thử"));

        existing.setStatus(normalizeStatus(status));
        trialRegistrationRepository.save(existing);
    }

    private void normalizeTrial(TrialRegistration trial) {
        trial.setFullname(trimToNull(trial.getFullname()));
        trial.setPhone(trimToNull(trial.getPhone()));
        trial.setEmail(trimToNull(trial.getEmail()));
        trial.setNote(trimToNull(trial.getNote()));
    }

    private String normalizeStatus(String status) {
        String normalized = trimToNull(status);
        if (normalized == null) {
            return "PENDING";
        }

        if ("PENDING".equalsIgnoreCase(normalized)) return "PENDING";
        if ("CONTACTED".equalsIgnoreCase(normalized)) return "CONTACTED";
        if ("DONE".equalsIgnoreCase(normalized)) return "DONE";
        if ("CANCELLED".equalsIgnoreCase(normalized)) return "CANCELLED";

        throw new IllegalArgumentException("Trạng thái đăng ký tập thử không hợp lệ");
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
}