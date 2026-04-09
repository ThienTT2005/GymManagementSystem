package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@Service
public class ServiceGymService {

    private final ServiceRepository serviceRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public ServiceGymService(ServiceRepository serviceRepository) {
        this.serviceRepository = serviceRepository;
    }

    public Page<ServiceGym> searchServices(String keyword, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size,
                Sort.by(Sort.Direction.DESC, "serviceId")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasStatus) {
            return serviceRepository.findByServiceNameContainingIgnoreCaseAndStatus(keyword.trim(), status, pageable);
        }

        if (hasKeyword) {
            return serviceRepository.findByServiceNameContainingIgnoreCase(keyword.trim(), pageable);
        }

        if (hasStatus) {
            return serviceRepository.findByStatus(status, pageable);
        }

        return serviceRepository.findAll(pageable);
    }

    public ServiceGym getServiceById(Integer id) {
        return serviceRepository.findById(id).orElse(null);
    }

    public boolean existsByServiceName(String serviceName, Integer excludeId) {
        if (serviceName == null || serviceName.trim().isEmpty()) {
            return false;
        }

        if (excludeId == null) {
            return serviceRepository.existsByServiceNameIgnoreCase(serviceName.trim());
        }

        return serviceRepository.existsByServiceNameIgnoreCaseAndServiceIdNot(serviceName.trim(), excludeId);
    }

    public ServiceGym createService(ServiceGym serviceGym, MultipartFile imageFile) {
        if (serviceGym.getStatus() == null) {
            serviceGym.setStatus(1);
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            serviceGym.setImage(saveImage(imageFile));
        }

        return serviceRepository.save(serviceGym);
    }

    public ServiceGym updateService(Integer id, ServiceGym formService, MultipartFile imageFile) {
        Optional<ServiceGym> optional = serviceRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        ServiceGym existing = optional.get();
        existing.setServiceName(formService.getServiceName());
        existing.setPrice(formService.getPrice());
        existing.setDescription(formService.getDescription());
        existing.setStatus(formService.getStatus());

        if (imageFile != null && !imageFile.isEmpty()) {
            existing.setImage(saveImage(imageFile));
        }

        return serviceRepository.save(existing);
    }

    public boolean softDeleteService(Integer id) {
        Optional<ServiceGym> optional = serviceRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        ServiceGym serviceGym = optional.get();
        serviceGym.setStatus(0);
        serviceRepository.save(serviceGym);
        return true;
    }

    private String saveImage(MultipartFile imageFile) {
        String originalFilename = imageFile.getOriginalFilename();
        String extension = "";

        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID() + extension;

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File dest = new File(dir, fileName);
        try {
            imageFile.transferTo(dest);
        } catch (IOException e) {
            throw new RuntimeException("Không thể upload ảnh", e);
        }

        return fileName;
    }
}