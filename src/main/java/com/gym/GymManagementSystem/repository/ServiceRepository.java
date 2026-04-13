package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.ServiceGym;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ServiceRepository extends JpaRepository<ServiceGym, Integer> {

    Page<ServiceGym> findByServiceNameContainingIgnoreCase(String keyword, Pageable pageable);

    Page<ServiceGym> findByStatus(Integer status, Pageable pageable);

    Page<ServiceGym> findByServiceNameContainingIgnoreCaseAndStatus(String keyword, Integer status, Pageable pageable);

    boolean existsByServiceNameIgnoreCase(String serviceName);

    boolean existsByServiceNameIgnoreCaseAndServiceIdNot(String serviceName, Integer serviceId);

    List<ServiceGym> findByStatus(Integer status);
}