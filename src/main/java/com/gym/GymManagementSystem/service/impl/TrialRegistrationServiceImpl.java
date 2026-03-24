package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.TrialRegistration;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TrialRegistrationServiceImpl implements TrialRegistrationService {

    private final TrialRegistrationRepository trialRegistrationRepository;

    public TrialRegistrationServiceImpl(TrialRegistrationRepository trialRegistrationRepository) {
        this.trialRegistrationRepository = trialRegistrationRepository;
    }

    @Override
    public List<TrialRegistration> findAll() {
        return trialRegistrationRepository.findAll();
    }

    @Override
    public TrialRegistration findById(Long id) {
        return trialRegistrationRepository.findById(id).orElse(null);
    }

    @Override
    public TrialRegistration save(TrialRegistration trialRegistration) {
        return trialRegistrationRepository.save(trialRegistration);
    }

    @Override
    public void deleteById(Long id) {
        trialRegistrationRepository.deleteById(id);
    }
}