package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Package;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PackageRepository extends JpaRepository<Package, Integer> {
    List<Package> findByStatusOrderByPrice(String status);
}