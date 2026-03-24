package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.News;
import org.springframework.data.domain.Page;

import java.util.List;

public interface NewsService {
    List<News> findAll();
    News findById(Long id);
    News save(News news);
    void deleteById(Long id);

    Page<News> searchNews(String keyword, int page, int size);
}