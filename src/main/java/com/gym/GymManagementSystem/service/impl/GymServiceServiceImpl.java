package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.GymService;
import com.gym.GymManagementSystem.repository.GymServiceRepository;
import com.gym.GymManagementSystem.service.GymServiceService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GymServiceServiceImpl implements GymServiceService {

    private final GymServiceRepository gymServiceRepository;

    public GymServiceServiceImpl(GymServiceRepository gymServiceRepository) {
        this.gymServiceRepository = gymServiceRepository;
    }

    @Override
    public List<GymService> findAll() {
        return gymServiceRepository.findAll();
    }

    @Override
    public GymService findById(Long id) {
        return gymServiceRepository.findById(id).orElse(null);
    }

    @Override
    public GymService save(GymService gymService) {
        return gymServiceRepository.save(gymService);
    }

    @Override
    public void deleteById(Long id) {
        gymServiceRepository.deleteById(id);
    }
}