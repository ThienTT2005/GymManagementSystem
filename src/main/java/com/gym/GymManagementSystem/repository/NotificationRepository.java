package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Notification;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    @Query("SELECT n " +
            "FROM Notification n " +
            "WHERE n.user.userId = :userId AND n.status = :status " +
            "ORDER BY n.isRead ASC, n.createdAt DESC")
    List<Notification> findLatestByUserId(Integer userId, Integer status, Pageable pageable);

    long countByUser_UserIdAndStatusAndIsRead(Integer userId, Integer status, Boolean isRead);

    Optional<Notification> findByNotificationIdAndUser_UserIdAndStatus(Integer notificationId, Integer userId, Integer status);
}