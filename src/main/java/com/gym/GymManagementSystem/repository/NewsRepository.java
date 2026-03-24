package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.News;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NewsRepository extends JpaRepository<News, Long> {

    @Query("""
        SELECT n
        FROM News n
        WHERE
            (:keyword IS NULL OR :keyword = '' OR
             LOWER(COALESCE(n.title, '')) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
             LOWER(COALESCE(n.content, '')) LIKE LOWER(CONCAT('%', :keyword, '%')))
    """)
    Page<News> searchNews(@Param("keyword") String keyword, Pageable pageable);
}