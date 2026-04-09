package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    @Query("""
        select p from Payment p
        left join p.membership m
        left join p.classRegistration cr
        left join m.member mm
        left join cr.member cm
        where lower(coalesce(mm.fullname, cm.fullname, '')) like lower(concat('%', :keyword, '%'))
    """)
    Page<Payment> searchByKeyword(String keyword, Pageable pageable);

    @Query("""
        select p from Payment p
        left join p.membership m
        left join p.classRegistration cr
        left join m.member mm
        left join cr.member cm
        where lower(coalesce(mm.fullname, cm.fullname, '')) like lower(concat('%', :keyword, '%'))
          and p.status = :status
    """)
    Page<Payment> searchByKeywordAndStatus(String keyword, String status, Pageable pageable);

    Page<Payment> findByStatus(String status, Pageable pageable);

    long countByStatus(String status);

    List<Payment> findAll(Sort sort);

    @Query("select coalesce(sum(p.amount), 0) from Payment p where p.status = 'PAID'")
    BigDecimal getTotalRevenue();

    @Query("""
        select function('DATE_FORMAT', p.paymentDate, '%Y-%m'), coalesce(sum(p.amount), 0)
        from Payment p
        where p.status = 'PAID' and p.paymentDate is not null
        group by function('DATE_FORMAT', p.paymentDate, '%Y-%m')
        order by function('DATE_FORMAT', p.paymentDate, '%Y-%m')
    """)
    List<Object[]> getMonthlyRevenue();
}