package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@Service
public class NewsService {

    private final NewsRepository newsRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public NewsService(NewsRepository newsRepository) {
        this.newsRepository = newsRepository;
    }

    public Page<News> searchNews(String keyword, String type, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size,
                Sort.by(Sort.Direction.DESC, "postId")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasType = type != null && !type.trim().isEmpty();
        boolean hasStatus = status != null;

        String kw = hasKeyword ? keyword.trim() : "";
        String tp = hasType ? type.trim() : "";

        if (hasKeyword && hasType && hasStatus) {
            return newsRepository.findByTitleContainingIgnoreCaseAndTypeAndStatus(kw, tp, status, pageable);
        }

        if (hasKeyword && hasType) {
            return newsRepository.findByTitleContainingIgnoreCaseAndType(kw, tp, pageable);
        }

        if (hasKeyword && hasStatus) {
            return newsRepository.findByTitleContainingIgnoreCaseAndStatus(kw, status, pageable);
        }

        if (hasType && hasStatus) {
            return newsRepository.findByTypeAndStatus(tp, status, pageable);
        }

        if (hasKeyword) {
            return newsRepository.findByTitleContainingIgnoreCase(kw, pageable);
        }

        if (hasType) {
            return newsRepository.findByType(tp, pageable);
        }

        if (hasStatus) {
            return newsRepository.findByStatus(status, pageable);
        }

        return newsRepository.findAll(pageable);
    }

    public News getNewsById(Integer id) {
        return newsRepository.findById(id).orElse(null);
    }

    public News createNews(News news, MultipartFile imageFile) {
        if (news.getStatus() == null) {
            news.setStatus(1);
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            news.setImage(saveImage(imageFile));
        }

        return newsRepository.save(news);
    }

    public News updateNews(Integer id, News formNews, MultipartFile imageFile) {
        Optional<News> optional = newsRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        News existing = optional.get();
        existing.setTitle(formNews.getTitle());
        existing.setContent(formNews.getContent());
        existing.setType(formNews.getType());
        existing.setStatus(formNews.getStatus());

        if (imageFile != null && !imageFile.isEmpty()) {
            existing.setImage(saveImage(imageFile));
        }

        return newsRepository.save(existing);
    }

    public boolean softDeleteNews(Integer id) {
        Optional<News> optional = newsRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        News news = optional.get();
        news.setStatus(0);
        newsRepository.save(news);
        return true;
    }

    private String saveImage(MultipartFile imageFile) {
        String originalFilename = imageFile.getOriginalFilename();
        String extension = "";

        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID() + extension;

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File dest = new File(dir, fileName);
        try {
            imageFile.transferTo(dest);
        } catch (IOException e) {
            throw new RuntimeException("Không thể upload ảnh bài viết", e);
        }

        return fileName;
    }
}