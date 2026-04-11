package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.News;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NewsRepository extends JpaRepository<News, Long> {

    Page<News> findByCategory(String category, Pageable pageable);

    Page<News> findByStatus(Integer status, Pageable pageable);

    Page<News> findByStatusAndCategory(Integer status, String category, Pageable pageable);

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