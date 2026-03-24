package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Club;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClubRepository extends JpaRepository<Club, Integer> {
}