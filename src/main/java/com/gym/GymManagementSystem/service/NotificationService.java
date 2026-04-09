package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.repository.NotificationRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public List<Notification> getLatestNotifications() {
        return notificationRepository.findTop5ByOrderByCreatedAtDesc();
    }
}