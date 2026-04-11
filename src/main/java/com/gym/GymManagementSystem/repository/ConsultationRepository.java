package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Consultation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConsultationRepository extends JpaRepository<Consultation, Integer> {

    Page<Consultation> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String fullname, String phone, String email, Pageable pageable
    );

    Page<Consultation> findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
            String fullname, String phone, String email, String status, Pageable pageable
    );

    Page<Consultation> findByStatus(String status, Pageable pageable);

    long countByStatus(String status);
}