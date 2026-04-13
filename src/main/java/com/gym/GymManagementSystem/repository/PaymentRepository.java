package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    @Query("""
        select p from Payment p
        left join p.membership m
        left join p.classRegistration cr
        left join m.member mm
        left join cr.member cm
        where (
            cast(p.paymentId as string) like concat('%', :keyword, '%')
            or lower(coalesce(mm.fullname, cm.fullname, '')) like lower(concat('%', :keyword, '%'))
            or lower(coalesce(p.note, '')) like lower(concat('%', :keyword, '%'))
            or (
                (:keyword = 'membership' or :keyword = 'package')
                and p.membership is not null
            )
            or (
                (:keyword = 'class' or :keyword = 'class registration')
                and p.classRegistration is not null
            )
        )
    """)
    Page<Payment> searchByKeyword(String keyword, Pageable pageable);

    @Query("""
        select p from Payment p
        left join p.membership m
        left join p.classRegistration cr
        left join m.member mm
        left join cr.member cm
        where (
            cast(p.paymentId as string) like concat('%', :keyword, '%')
            or lower(coalesce(mm.fullname, cm.fullname, '')) like lower(concat('%', :keyword, '%'))
            or lower(coalesce(p.note, '')) like lower(concat('%', :keyword, '%'))
            or (
                (:keyword = 'membership' or :keyword = 'package')
                and p.membership is not null
            )
            or (
                (:keyword = 'class' or :keyword = 'class registration')
                and p.classRegistration is not null
            )
        )
        and p.status = :status
    """)
    Page<Payment> searchByKeywordAndStatus(String keyword, String status, Pageable pageable);

    @Query("""
        select p from Payment p
        left join p.membership m
        left join p.classRegistration cr
        left join m.member mm
        left join cr.member cm
        where (:keyword is null or
               cast(p.paymentId as string) like concat('%', :keyword, '%')
               or lower(coalesce(mm.fullname, cm.fullname, '')) like lower(concat('%', :keyword, '%'))
               or lower(coalesce(p.note, '')) like lower(concat('%', :keyword, '%'))
               or ((:keyword = 'membership' or :keyword = 'package') and p.membership is not null)
               or ((:keyword = 'class' or :keyword = 'class registration') and p.classRegistration is not null))
          and (:status is null or p.status = :status)
          and (:paymentMethod is null or lower(p.paymentMethod) = lower(:paymentMethod))
          and (:fromDate is null or p.paymentDate >= :fromDate)
          and (:toDate is null or p.paymentDate <= :toDate)
    """)
    Page<Payment> searchAdminPayments(String keyword,
                                      String status,
                                      String paymentMethod,
                                      LocalDate fromDate,
                                      LocalDate toDate,
                                      Pageable pageable);

    Page<Payment> findByStatus(String status, Pageable pageable);

    long countByStatus(String status);

    List<Payment> findAll(Sort sort);

    Optional<Payment> findTopByMembershipMembershipIdOrderByCreatedAtDesc(Integer membershipId);

    Optional<Payment> findTopByClassRegistrationRegistrationIdOrderByCreatedAtDesc(Integer registrationId);

    @Query("""
        select p
        from Payment p
        left join p.membership m
        left join m.member mm
        left join p.classRegistration cr
        left join cr.member cm
        where (mm.memberId = :memberId or cm.memberId = :memberId)
        order by p.createdAt desc
    """)
    List<Payment> findByMemberId(Integer memberId);

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

    @Query("select coalesce(sum(p.amount), 0) from Payment p where p.status = 'PAID'")
    BigDecimal sumPaidRevenue();

    @Query("""
        select p.packageName, count(m.membershipId)
        from Membership m
        join m.gymPackage p
        group by p.packageName
        order by count(m.membershipId) desc
    """)
    List<Object[]> getTopPackages();
}