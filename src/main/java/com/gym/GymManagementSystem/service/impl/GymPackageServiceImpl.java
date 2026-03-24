package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.GymPackage;
import com.gym.GymManagementSystem.repository.GymPackageRepository;
import com.gym.GymManagementSystem.service.GymPackageService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GymPackageServiceImpl implements GymPackageService {

    private final GymPackageRepository gymPackageRepository;

    public GymPackageServiceImpl(GymPackageRepository gymPackageRepository) {
        this.gymPackageRepository = gymPackageRepository;
    }

    @Override
    public List<GymPackage> findAll() {
        return gymPackageRepository.findAll();
    }

    @Override
    public GymPackage findById(Long id) {
        return gymPackageRepository.findById(id).orElse(null);
    }

    @Override
    public GymPackage save(GymPackage gymPackage) {
        return gymPackageRepository.save(gymPackage);
    }

    @Override
    public void deleteById(Long id) {
        gymPackageRepository.deleteById(id);
    }
}