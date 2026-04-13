package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Trainer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TrainerRepository extends JpaRepository<Trainer, Integer> {

    @org.springframework.data.jpa.repository.Query("""
        select t from Trainer t
        left join t.staff s
        where lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(t.specialty, '')) like lower(concat('%', :keyword, '%'))
    """)
    Page<Trainer> searchByKeyword(String keyword, Pageable pageable);

    @org.springframework.data.jpa.repository.Query("""
        select t from Trainer t
        left join t.staff s
        where (lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(t.specialty, '')) like lower(concat('%', :keyword, '%')))
          and t.status = :status
    """)
    Page<Trainer> searchByKeywordAndStatus(String keyword, Integer status, Pageable pageable);

    Page<Trainer> findByStatus(Integer status, Pageable pageable);

    boolean existsByStaff_StaffId(Integer staffId);

    boolean existsByStaff_StaffIdAndTrainerIdNot(Integer staffId, Integer trainerId);

    List<Trainer> findAll(Sort sort);

    Optional<Trainer> findByStaff_User_UserId(Integer userId);
}