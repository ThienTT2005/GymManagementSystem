package com.gym.GymManagementSystem.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class UploadConfig {

    @Value("${app.upload.dir}")
    private String uploadDir;

    public String getUploadDir() {
        return uploadDir;
    }
}