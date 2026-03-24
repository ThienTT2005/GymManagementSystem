package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.Contact;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ContactRepository extends JpaRepository<Contact, Long> {

    @Query("""
        SELECT c
        FROM Contact c
        WHERE
            (:keyword IS NULL OR :keyword = '' OR
             LOWER(COALESCE(c.fullName, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(c.email, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(c.phone, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(c.message, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
        AND
            (:status IS NULL OR :status = '' OR c.status = :status)
    """)
    Page<Contact> searchContacts(@Param("keyword") String keyword,
                                 @Param("status") String status,
                                 Pageable pageable);
}