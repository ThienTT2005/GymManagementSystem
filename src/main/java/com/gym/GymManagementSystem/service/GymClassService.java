package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import com.gym.GymManagementSystem.repository.TrainerRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GymClassService {

    private final GymClassRepository gymClassRepository;
    private final ServiceRepository serviceRepository;
    private final TrainerRepository trainerRepository;

    public GymClassService(GymClassRepository gymClassRepository,
                           ServiceRepository serviceRepository,
                           TrainerRepository trainerRepository) {
        this.gymClassRepository = gymClassRepository;
        this.serviceRepository = serviceRepository;
        this.trainerRepository = trainerRepository;
    }

    public Page<GymClass> searchClasses(String keyword, Integer serviceId, Integer trainerId, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "classId"));
        Page<GymClass> base;

        if (keyword != null && !keyword.trim().isEmpty() && status != null) {
            base = gymClassRepository.findByClassNameContainingIgnoreCaseAndStatus(keyword.trim(), status, pageable);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            base = gymClassRepository.findByClassNameContainingIgnoreCase(keyword.trim(), pageable);
        } else if (serviceId != null) {
            base = gymClassRepository.findByService_ServiceId(serviceId, pageable);
        } else if (trainerId != null) {
            base = gymClassRepository.findByTrainer_TrainerId(trainerId, pageable);
        } else if (status != null) {
            base = gymClassRepository.findByStatus(status, pageable);
        } else {
            base = gymClassRepository.findAll(pageable);
        }

        return base.map(c -> c);
    }

    public GymClass getClassById(Integer id) {
        return gymClassRepository.findById(id).orElse(null);
    }

    public List<ServiceGym> getAllServices() {
        return serviceRepository.findAll(Sort.by(Sort.Direction.ASC, "serviceName"));
    }

    public List<Trainer> getAllTrainers() {
        return trainerRepository.findAll(Sort.by(Sort.Direction.ASC, "trainerId"));
    }

    public GymClass createClass(GymClass gymClass, Integer serviceId, Integer trainerId) {
        bindRelations(gymClass, serviceId, trainerId);
        if (gymClass.getStatus() == null) {
            gymClass.setStatus(1);
        }
        if (gymClass.getCurrentMember() == null) {
            gymClass.setCurrentMember(0);
        }
        return gymClassRepository.save(gymClass);
    }

    public GymClass updateClass(Integer id, GymClass formClass, Integer serviceId, Integer trainerId) {
        Optional<GymClass> optional = gymClassRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        GymClass existing = optional.get();
        existing.setClassName(formClass.getClassName());
        existing.setDescription(formClass.getDescription());
        existing.setMaxMember(formClass.getMaxMember());
        existing.setCurrentMember(formClass.getCurrentMember());
        existing.setStatus(formClass.getStatus());

        bindRelations(existing, serviceId, trainerId);
        return gymClassRepository.save(existing);
    }

    public boolean softDeleteClass(Integer id) {
        Optional<GymClass> optional = gymClassRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        GymClass gymClass = optional.get();
        gymClass.setStatus(0);
        gymClassRepository.save(gymClass);
        return true;
    }

    private void bindRelations(GymClass gymClass, Integer serviceId, Integer trainerId) {
        ServiceGym service = serviceId != null ? serviceRepository.findById(serviceId).orElse(null) : null;
        Trainer trainer = trainerId != null ? trainerRepository.findById(trainerId).orElse(null) : null;

        gymClass.setService(service);
        gymClass.setTrainer(trainer);
    }
}