package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.Club;

import java.util.List;

public interface ClubService {
    List<Club> findAll();
    Club findById(Long id);
    Club save(Club club);
    void deleteById(Long id);
}