package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Staff;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StaffRepository extends JpaRepository<Staff, Integer> {

    @org.springframework.data.jpa.repository.Query("""
        select s from Staff s
        where lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(s.phone, '')) like lower(concat('%', :keyword, '%'))
    """)
    Page<Staff> searchByKeyword(String keyword, Pageable pageable);

    @org.springframework.data.jpa.repository.Query("""
        select s from Staff s
        where (lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(s.phone, '')) like lower(concat('%', :keyword, '%')))
          and lower(coalesce(s.position, '')) like lower(concat('%', :position, '%'))
    """)
    Page<Staff> searchByKeywordAndPosition(String keyword, String position, Pageable pageable);

    @org.springframework.data.jpa.repository.Query("""
        select s from Staff s
        where (lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(s.phone, '')) like lower(concat('%', :keyword, '%')))
          and s.status = :status
    """)
    Page<Staff> searchByKeywordAndStatus(String keyword, Integer status, Pageable pageable);

    @org.springframework.data.jpa.repository.Query("""
        select s from Staff s
        where (lower(coalesce(s.fullName, '')) like lower(concat('%', :keyword, '%'))
           or lower(coalesce(s.phone, '')) like lower(concat('%', :keyword, '%')))
          and lower(coalesce(s.position, '')) like lower(concat('%', :position, '%'))
          and s.status = :status
    """)
    Page<Staff> searchByKeywordAndPositionAndStatus(String keyword, String position, Integer status, Pageable pageable);

    boolean existsByUser_UserId(Integer userId);

    boolean existsByUser_UserIdAndStaffIdNot(Integer userId, Integer staffId);

    List<Staff> findAll(Sort sort);
}