package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    long countByStatus(String status);

    List<Payment> findTop5ByStatusOrderByPaymentDateDesc(String status);

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = 'Đã duyệt'")
    BigDecimal getTotalRevenue();

    @Query("SELECT MONTH(p.paymentDate), SUM(p.amount) " +
            "FROM Payment p " +
            "WHERE p.status = 'Đã duyệt' " +
            "GROUP BY MONTH(p.paymentDate) " +
            "ORDER BY MONTH(p.paymentDate)")
    List<Object[]> getMonthlyRevenue();

    @Query("SELECT MONTH(p.paymentDate), " +
            "COALESCE(SUM(CASE WHEN YEAR(p.paymentDate) = :currentYear THEN p.amount ELSE 0 END), 0), " +
            "COALESCE(SUM(CASE WHEN YEAR(p.paymentDate) = :previousYear THEN p.amount ELSE 0 END), 0) " +
            "FROM Payment p " +
            "WHERE p.status = 'Đã duyệt' " +
            "AND YEAR(p.paymentDate) IN (:currentYear, :previousYear) " +
            "GROUP BY MONTH(p.paymentDate) " +
            "ORDER BY MONTH(p.paymentDate)")
    List<Object[]> getMonthlyRevenueComparison(@Param("currentYear") int currentYear,
                                               @Param("previousYear") int previousYear);

    @Query("SELECT p.packageName, COUNT(p) " +
            "FROM Payment p " +
            "WHERE p.status = 'Đã duyệt' " +
            "GROUP BY p.packageName " +
            "ORDER BY COUNT(p) DESC")
    List<Object[]> getTopPackages();

    @Query("""
        SELECT p
        FROM Payment p
        WHERE
            (:keyword IS NULL OR :keyword = '' OR
             LOWER(COALESCE(p.memberName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(p.packageName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(p.paymentMethod, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
        AND
            (:status IS NULL OR :status = '' OR p.status = :status)
    """)
    Page<Payment> searchPayments(@Param("keyword") String keyword,
                                 @Param("status") String status,
                                 Pageable pageable);
}