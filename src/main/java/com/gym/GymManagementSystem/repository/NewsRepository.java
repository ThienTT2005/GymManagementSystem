package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.News;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NewsRepository extends JpaRepository<News, Integer> {

    Page<News> findByTitleContainingIgnoreCase(String keyword, Pageable pageable);

    Page<News> findByType(String type, Pageable pageable);

    Page<News> findByStatus(Integer status, Pageable pageable);

    Page<News> findByTypeAndStatus(String type, Integer status, Pageable pageable);

    Page<News> findByTitleContainingIgnoreCaseAndType(String keyword, String type, Pageable pageable);

    Page<News> findByTitleContainingIgnoreCaseAndStatus(String keyword, Integer status, Pageable pageable);

    Page<News> findByTitleContainingIgnoreCaseAndTypeAndStatus(
            String keyword, String type, Integer status, Pageable pageable
    );
}