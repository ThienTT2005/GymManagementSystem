package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    List<Notification> findTop5ByOrderByCreatedAtDesc();
}