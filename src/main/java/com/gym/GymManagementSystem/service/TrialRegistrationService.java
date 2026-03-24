package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.TrialRegistration;

import java.util.List;

public interface TrialRegistrationService {
    List<TrialRegistration> findAll();
    TrialRegistration findById(Long id);
    TrialRegistration save(TrialRegistration trialRegistration);
    void deleteById(Long id);
}