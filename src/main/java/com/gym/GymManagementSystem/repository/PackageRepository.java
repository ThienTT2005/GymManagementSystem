package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.GymPackage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PackageRepository extends JpaRepository<GymPackage, Integer> {

    Page<GymPackage> findByPackageNameContainingIgnoreCase(String keyword, Pageable pageable);

    Page<GymPackage> findByStatus(Integer status, Pageable pageable);

    Page<GymPackage> findByPackageNameContainingIgnoreCaseAndStatus(String keyword, Integer status, Pageable pageable);

    Optional<GymPackage> findByPackageNameIgnoreCase(String packageName);

    boolean existsByPackageNameIgnoreCase(String packageName);

    boolean existsByPackageNameIgnoreCaseAndPackageIdNot(String packageName, Integer packageId);
}