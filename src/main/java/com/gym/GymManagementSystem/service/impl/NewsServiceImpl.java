package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.dto.NewsPageResponseDto;
import com.gym.GymManagementSystem.dto.NewsResponseDto;
import com.gym.GymManagementSystem.entity.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import com.gym.GymManagementSystem.service.NewsService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class NewsServiceImpl implements NewsService {

    private final NewsRepository newsRepository;

    public NewsServiceImpl(NewsRepository newsRepository) {
        this.newsRepository = newsRepository;
    }

    @Override
    public NewsPageResponseDto getNews(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<News> newsPage;

        if (category != null && !category.trim().isEmpty()) {
            newsPage = newsRepository.findByCategoryAndStatus(category.trim(), 1, pageable);
        } else {
            newsPage = newsRepository.findByStatus(1, pageable);
        }

        List<NewsResponseDto> newsList = newsPage.getContent()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        NewsPageResponseDto response = new NewsPageResponseDto();
        response.setNewsList(newsList);
        response.setCurrentPage(newsPage.getNumber());
        response.setTotalPages(newsPage.getTotalPages());
        response.setTotalItems(newsPage.getTotalElements());
        response.setPageSize(newsPage.getSize());
        response.setHasNext(newsPage.hasNext());
        response.setHasPrevious(newsPage.hasPrevious());

        return response;
    }

    @Override
    public Page<News> searchNews(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);

        if (keyword == null || keyword.trim().isEmpty()) {
            return newsRepository.findByStatus(1, pageable);
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
        NewsResponseDto dto = new NewsResponseDto();
        dto.setPostId(news.getPostId());
        dto.setTitle(news.getTitle());
        dto.setContent(news.getContent());
        dto.setImage(news.getImage());
        dto.setCategory(news.getCategory());
        dto.setStatus(news.getStatus());
        dto.setCreatedAt(news.getCreatedAt());
        dto.setUpdatedAt(news.getUpdatedAt());
        return dto;
    }
}