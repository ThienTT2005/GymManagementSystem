package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.ScheduleRepository;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ServiceGymService {

    private final ServiceRepository serviceRepository;
    private final GymClassRepository gymClassRepository;
    private final ScheduleRepository scheduleRepository;
    private final ClassRegistrationRepository classRegistrationRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public ServiceGymService(ServiceRepository serviceRepository,
                             GymClassRepository gymClassRepository,
                             ScheduleRepository scheduleRepository,
                             ClassRegistrationRepository classRegistrationRepository) {
        this.serviceRepository = serviceRepository;
        this.gymClassRepository = gymClassRepository;
        this.scheduleRepository = scheduleRepository;
        this.classRegistrationRepository = classRegistrationRepository;
    }

    public Page<ServiceGym> searchServices(String keyword, Integer status, int page, int size) {
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;

        PageRequest pageable = PageRequest.of(safePage, safeSize);

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        Page<ServiceGym> rawPage;

        if (hasKeyword && hasStatus) {
            rawPage = serviceRepository.findByServiceNameContainingIgnoreCaseAndStatus(keyword.trim(), status, pageable);
        } else if (hasKeyword) {
            rawPage = serviceRepository.findByServiceNameContainingIgnoreCase(keyword.trim(), pageable);
        } else if (hasStatus) {
            rawPage = serviceRepository.findByStatus(status, pageable);
        } else {
            rawPage = serviceRepository.findAll(pageable);
        }

        List<ServiceGym> sortedContent = rawPage.getContent().stream()
                .sorted(serviceNameComparator())
                .toList();

        return new PageImpl<>(sortedContent, pageable, rawPage.getTotalElements());
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
        normalizeService(serviceGym);

        if (serviceGym.getStatus() == null) {
            serviceGym.setStatus(1);
        }

        validateService(serviceGym);

        if (imageFile != null && !imageFile.isEmpty()) {
            serviceGym.setImage(saveImage(imageFile));
        }

        ServiceGym saved = serviceRepository.save(serviceGym);

        if (saved.getStatus() != null && saved.getStatus() == 0) {
            deactivateRelatedClasses(saved.getServiceId());
        }

        return saved;
    }

    public ServiceGym updateService(Integer id, ServiceGym formService, MultipartFile imageFile) {
        Optional<ServiceGym> optional = serviceRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        ServiceGym existing = optional.get();

        normalizeService(formService);
        validateService(formService);

        existing.setServiceName(formService.getServiceName());
        existing.setPrice(formService.getPrice());
        existing.setDescription(formService.getDescription());
        existing.setStatus(formService.getStatus());

        if (imageFile != null && !imageFile.isEmpty()) {
            existing.setImage(saveImage(imageFile));
        }

        ServiceGym saved = serviceRepository.save(existing);

        if (saved.getStatus() != null && saved.getStatus() == 0) {
            deactivateRelatedClasses(saved.getServiceId());
        }

        return saved;
    }

    public void updateStatus(Integer id, Integer status) {
        if (id == null) {
            throw new IllegalArgumentException("Không tìm thấy dịch vụ");
        }

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        ServiceGym serviceGym = serviceRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy dịch vụ"));

        serviceGym.setStatus(status);
        ServiceGym saved = serviceRepository.save(serviceGym);

        if (saved.getStatus() != null && saved.getStatus() == 0) {
            deactivateRelatedClasses(saved.getServiceId());
        }
    }

    public boolean softDeleteService(Integer id) {
        Optional<ServiceGym> optional = serviceRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        ServiceGym serviceGym = optional.get();
        serviceGym.setStatus(0);
        serviceRepository.save(serviceGym);

        deactivateRelatedClasses(serviceGym.getServiceId());
        return true;
    }

    private Comparator<ServiceGym> serviceNameComparator() {
        return Comparator
                .comparing((ServiceGym service) -> normalizeServiceName(service.getServiceName()))
                .thenComparing(ServiceGym::getServiceId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private String normalizeServiceName(String value) {
        if (value == null) {
            return "";
        }

        return Normalizer.normalize(value.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase();
    }

    private void normalizeService(ServiceGym serviceGym) {
        if (serviceGym == null) {
            throw new IllegalArgumentException("Thông tin dịch vụ không hợp lệ");
        }

        if (serviceGym.getServiceName() != null) {
            serviceGym.setServiceName(serviceGym.getServiceName().trim());
        }

        if (serviceGym.getDescription() != null) {
            serviceGym.setDescription(serviceGym.getDescription().trim());
        }
    }

    private void validateService(ServiceGym serviceGym) {
        if (serviceGym == null) {
            throw new IllegalArgumentException("Thông tin dịch vụ không hợp lệ");
        }

        if (serviceGym.getServiceName() == null || serviceGym.getServiceName().isBlank()) {
            throw new IllegalArgumentException("Tên dịch vụ không được để trống");
        }

        if (serviceGym.getPrice() == null) {
            throw new IllegalArgumentException("Giá dịch vụ không được để trống");
        }

        if (serviceGym.getPrice().doubleValue() < 0) {
            throw new IllegalArgumentException("Giá dịch vụ không hợp lệ");
        }

        if (serviceGym.getStatus() == null || (serviceGym.getStatus() != 0 && serviceGym.getStatus() != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }
    }

    private void deactivateRelatedClasses(Integer serviceId) {
        if (serviceId == null) {
            return;
        }

        List<GymClass> classes = gymClassRepository.findAll();
        for (GymClass gymClass : classes) {
            if (gymClass.getService() != null
                    && serviceId.equals(gymClass.getService().getServiceId())) {

                gymClass.setStatus(0);
                gymClass.setCurrentMember(0);
                gymClassRepository.save(gymClass);

                List<Schedule> schedules = scheduleRepository.findAll();
                for (Schedule schedule : schedules) {
                    if (schedule.getGymClass() != null
                            && gymClass.getClassId().equals(schedule.getGymClass().getClassId())) {
                        schedule.setStatus(0);
                        scheduleRepository.save(schedule);
                    }
                }

                List<ClassRegistration> registrations = classRegistrationRepository.findAll();
                for (ClassRegistration registration : registrations) {
                    if (registration.getGymClass() != null
                            && gymClass.getClassId().equals(registration.getGymClass().getClassId())) {
                        registration.setStatus("CANCELLED");
                        classRegistrationRepository.save(registration);
                    }
                }
            }
        }
    }

    private String saveImage(MultipartFile imageFile) {
        String originalFilename = imageFile.getOriginalFilename();
        String extension = "";

        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID() + extension;

        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);

            Path destination = uploadPath.resolve(fileName);
            Files.copy(imageFile.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new RuntimeException("Không thể upload ảnh", e);
        }

        return fileName;
    }
}