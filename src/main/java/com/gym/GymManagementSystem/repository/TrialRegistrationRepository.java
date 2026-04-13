package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.TrialRegistration;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrialRegistrationRepository extends JpaRepository<TrialRegistration, Integer> {

    Page<TrialRegistration> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String fullname, String phone, String email, Pageable pageable
    );

    Page<TrialRegistration> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
            String fullname, String phone, String email, String status, Pageable pageable
    );

    Page<TrialRegistration> findByStatus(String status, Pageable pageable);

    long countByStatus(String status);

    boolean existsByPhone(String phone);
}