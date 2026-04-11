package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.entity.News;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface NewsService {

    NewsPageResponseDto getNews(String category, int page, int size);

    Page<News> searchNews(String keyword, int page, int size);

    News save(News news);

    Optional<News> findById(Long id);

    void deleteById(Long id);
}