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
import java.nio.file.*;
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

    // ================= SEARCH =================
    public Page<News> searchNews(String keyword, String category, Integer status, int page, int size) {

        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size > 0 ? size : 8,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty();
        boolean hasStatus = status != null;

        String kw = hasKeyword ? keyword.trim() : "";
        String ct = hasCategory ? category.trim() : "";

        if (hasKeyword && hasCategory && hasStatus) {
            return newsRepository.findByTitleContainingIgnoreCaseAndTypeAndStatus(kw, ct, status, pageable);
        }

        if (hasKeyword && hasCategory) {
            return newsRepository.findByTitleContainingIgnoreCaseAndType(kw, ct, pageable);
        }

        if (hasKeyword && hasStatus) {
            return newsRepository.findByTitleContainingIgnoreCaseAndStatus(kw, status, pageable);
        }

        if (hasCategory && hasStatus) {
            return newsRepository.findByTypeAndStatus(ct, status, pageable);
        }

        if (hasKeyword) {
            return newsRepository.findByTitleContainingIgnoreCase(kw, pageable);
        }

        if (hasCategory) {
            return newsRepository.findByType(ct, pageable);
        }

        if (hasStatus) {
            return newsRepository.findByStatus(status, pageable);
        }

        return newsRepository.findAll(pageable);
    }

    // ================= GET =================
    public News getNewsById(Integer id) {
        return newsRepository.findById(id).orElse(null);
    }

    // ================= CREATE =================
    public News createNews(News news, MultipartFile imageFile) {

        if (news.getStatus() == null) {
            news.setStatus(1);
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            news.setImage(saveImage(imageFile));
        }

        return newsRepository.save(news);
    }

    // ================= UPDATE =================
    public News updateNews(Integer id, News formNews, MultipartFile imageFile) {

        Optional<News> optional = newsRepository.findById(id);
        if (optional.isEmpty()) return null;

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

    // ================= STATUS =================
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

    // ================= DELETE =================
    public boolean softDeleteNews(Integer id) {

        Optional<News> optional = newsRepository.findById(id);
        if (optional.isEmpty()) return false;

        News news = optional.get();
        news.setStatus(0);
        newsRepository.save(news);

        return true;
    }

    // ================= UPLOAD IMAGE =================
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
