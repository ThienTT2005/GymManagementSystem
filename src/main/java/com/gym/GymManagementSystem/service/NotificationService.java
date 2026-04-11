package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Notification;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.NotificationRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public NotificationService(NotificationRepository notificationRepository,
                               UserRepository userRepository) {
        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
    }

    public List<Notification> getLatestNotificationsByUserId(Integer userId, int limit) {
        if (userId == null) {
            return Collections.emptyList();
        }

        int safeLimit = limit > 0 ? limit : 6;

        return notificationRepository.findLatestByUserId(
                userId,
                1,
                PageRequest.of(0, safeLimit)
        );
    }

    public long countUnreadByUserId(Integer userId) {
        if (userId == null) {
            return 0;
        }
        return notificationRepository.countByUser_UserIdAndStatusAndIsRead(userId, 1, false);
    }

    public Notification createNotification(Integer userId, String title, String message, String targetUrl) {
        if (userId == null || title == null || title.isBlank()) {
            return null;
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return null;
        }

        Notification notification = new Notification();
        notification.setUser(user);
        notification.setTitle(title.trim());
        notification.setMessage(message != null ? message.trim() : null);
        notification.setTargetUrl(targetUrl != null ? targetUrl.trim() : null);
        notification.setIsRead(false);
        notification.setStatus(1);

        return notificationRepository.save(notification);
    }

    public void markAsRead(Integer notificationId, Integer userId) {
        if (notificationId == null || userId == null) {
            return;
        }

        notificationRepository.findByNotificationIdAndUser_UserIdAndStatus(notificationId, userId, 1)
                .ifPresent(notification -> {
                    if (!Boolean.TRUE.equals(notification.getIsRead())) {
                        notification.setIsRead(true);
                        notificationRepository.save(notification);
                    }
                });
    }
}