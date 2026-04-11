package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.dto.NewsResponseDto;
import com.gym.GymManagementSystem.entity.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsRepository newsRepository;

    @Override
    public NewsPageResponseDto getNews(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page - 1, size);

        Page<News> newsPage;

        if (category == null || category.trim().isEmpty()) {
            newsPage = newsRepository.findByStatus(1, pageable);
        } else {
            newsPage = newsRepository.findByStatusAndCategory(1, category, pageable);
        }

        List<NewsResponseDto> content = newsPage.getContent()
                .stream()
                .map(this::convertToDto)
                .toList();

        return new NewsPageResponseDto(content, page, newsPage.getTotalPages());
    }

    @Override
    public Page<News> searchNews(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page - 1, size);

        if (keyword == null || keyword.trim().isEmpty()) {
            return newsRepository.findAll(pageable);
        }

        return newsRepository.searchNews(keyword.trim(), pageable);
    }

    @Override
    public News save(News news) {
        return newsRepository.save(news);
    }

    @Override
    public Optional<News> findById(Long id) {
        return newsRepository.findById(id);
    }

    @Override
    public void deleteById(Long id) {
        newsRepository.deleteById(id);
    }

    private NewsResponseDto convertToDto(News news) {
        return new NewsResponseDto(
                news.getPostId(),
                news.getTitle(),
                news.getContent(),
                news.getImage(),
                news.getCategory(),
                news.getCreatedAt()
        );
    }
}