package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
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
                size > 0 ? size : 8,
                Sort.by(Sort.Direction.DESC, "createdAt")
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

    public void updateStatus(Integer id, Integer status) {
        if (id == null) {
            throw new IllegalArgumentException("Không tìm thấy bài viết");
        }

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        News news = newsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài viết"));

        news.setStatus(status);
        newsRepository.save(news);
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

    // ✅ FIX CHUẨN 100%
    private String saveImage(MultipartFile imageFile) {
        String originalFilename = imageFile.getOriginalFilename();
        String extension = "";

        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID() + extension;

        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);

            Path destination = uploadPath.resolve(fileName);

            Files.copy(
                    imageFile.getInputStream(),
                    destination,
                    StandardCopyOption.REPLACE_EXISTING
            );

        } catch (IOException e) {
            throw new RuntimeException("Không thể upload ảnh bài viết", e);
        }

        return fileName;
    }
}
