package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.GymClass;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GymClassRepository extends JpaRepository<GymClass, Integer> {

    Page<GymClass> findByClassNameContainingIgnoreCase(String className, Pageable pageable);

    Page<GymClass> findByService_ServiceId(Integer serviceId, Pageable pageable);

    Page<GymClass> findByTrainer_TrainerId(Integer trainerId, Pageable pageable);

    Page<GymClass> findByStatus(Integer status, Pageable pageable);

    Page<GymClass> findByClassNameContainingIgnoreCaseAndStatus(String className, Integer status, Pageable pageable);

    List<GymClass> findAll(Sort sort);

    List<GymClass> findByStatusOrderByCurrentMemberDesc(Integer status, Pageable pageable);

    List<GymClass> findAllByStatus(Integer status);
}