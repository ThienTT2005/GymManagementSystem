package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.ClassRegistration;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClassRegistrationRepository extends JpaRepository<ClassRegistration, Integer> {

    Page<ClassRegistration> findByMember_FullnameContainingIgnoreCase(String fullname, Pageable pageable);

    Page<ClassRegistration> findByStatus(String status, Pageable pageable);

    Page<ClassRegistration> findByGymClass_ClassId(Integer classId, Pageable pageable);

    Page<ClassRegistration> findByMember_FullnameContainingIgnoreCaseAndStatus(
            String fullname, String status, Pageable pageable
    );

    Page<ClassRegistration> findByGymClass_ClassIdAndStatus(
            Integer classId, String status, Pageable pageable
    );

    Page<ClassRegistration> findByMember_FullnameContainingIgnoreCaseAndGymClass_ClassIdAndStatus(
            String fullname, Integer classId, String status, Pageable pageable
    );

    long countByStatus(String status);

    List<ClassRegistration> findByGymClass_ClassIdAndStatus(Integer classId, String status);

    List<ClassRegistration> findAll(Sort sort);
}