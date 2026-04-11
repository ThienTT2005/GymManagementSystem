package com.gym.GymManagementSystem.dto;

import java.time.LocalDateTime;

public class NewsResponseDto {
    private Long postId;
    private String title;
    private String content;
    private String imageUrl;
    private String category;
    private LocalDateTime createdAt;

    public NewsResponseDto() {
    }

    public NewsResponseDto(Long postId, String title, String content, String imageUrl, String category, LocalDateTime createdAt) {
        this.postId = postId;
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.category = category;
        this.createdAt = createdAt;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}