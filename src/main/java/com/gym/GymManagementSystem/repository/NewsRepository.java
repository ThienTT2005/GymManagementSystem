package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.entity.News;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NewsRepository extends JpaRepository<News, Long> {

    Page<News> findByStatus(Integer status, Pageable pageable);

    Page<News> findByCategoryAndStatus(String category, Integer status, Pageable pageable);

    @Query("""
        SELECT n
        FROM News n
        WHERE n.status = 1
          AND (
                LOWER(n.title) LIKE LOWER(CONCAT('%', :keyword, '%'))
                OR LOWER(n.content) LIKE LOWER(CONCAT('%', :keyword, '%'))
                OR LOWER(n.category) LIKE LOWER(CONCAT('%', :keyword, '%'))
              )
    """)
    Page<News> searchNews(@Param("keyword") String keyword, Pageable pageable);
}