package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.Club;
import com.gym.GymManagementSystem.repository.ClubRepository;
import com.gym.GymManagementSystem.service.ClubService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClubServiceImpl implements ClubService {

    private final ClubRepository clubRepository;

    public ClubServiceImpl(ClubRepository clubRepository) {
        this.clubRepository = clubRepository;
    }

    @Override
    public List<Club> findAll() {
        return clubRepository.findAll();
    }

    @Override
    public Club findById(Long id) {
        return clubRepository.findById(id).orElse(null);
    }

    @Override
    public Club save(Club club) {
        return clubRepository.save(club);
    }

    @Override
    public void deleteById(Long id) {
        clubRepository.deleteById(id);
    }
}