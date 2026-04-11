package com.gym.GymManagementSystem.dto;

import java.util.List;

public class NewsPageResponseDto {
    private List<NewsResponseDto> content;
    private int page;
    private int totalPages;

    public NewsPageResponseDto() {
    }

    public NewsPageResponseDto(List<NewsResponseDto> content, int page, int totalPages) {
        this.content = content;
        this.page = page;
        this.totalPages = totalPages;
    }

    public List<NewsResponseDto> getContent() {
        return content;
    }

    public void setContent(List<NewsResponseDto> content) {
        this.content = content;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
}