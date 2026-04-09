package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.repository.PackageRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class PackageService {

    private final PackageRepository packageRepository;

    @Value("${app.upload.dir}")
    private String uploadDir;

    public PackageService(PackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    public Page<GymPackage> searchPackages(String keyword, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size,
                Sort.by(Sort.Direction.DESC, "packageId")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasStatus) {
            return packageRepository.findByPackageNameContainingIgnoreCaseAndStatus(keyword.trim(), status, pageable);
        }

        if (hasKeyword) {
            return packageRepository.findByPackageNameContainingIgnoreCase(keyword.trim(), pageable);
        }

        if (hasStatus) {
            return packageRepository.findByStatus(status, pageable);
        }

        return packageRepository.findAll(pageable);
    }

    public List<GymPackage> findAll() {
        return packageRepository.findAll(Sort.by(Sort.Direction.ASC, "packageName"));
    }

    public GymPackage getPackageById(Integer id) {
        return packageRepository.findById(id).orElse(null);
    }

    public boolean existsByPackageName(String packageName, Integer excludeId) {
        if (packageName == null || packageName.trim().isEmpty()) {
            return false;
        }

        if (excludeId == null) {
            return packageRepository.existsByPackageNameIgnoreCase(packageName.trim());
        }

        return packageRepository.existsByPackageNameIgnoreCaseAndPackageIdNot(packageName.trim(), excludeId);
    }

    public GymPackage createPackage(GymPackage gymPackage, MultipartFile imageFile) {
        if (gymPackage.getStatus() == null) {
            gymPackage.setStatus(1);
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            gymPackage.setImage(saveImage(imageFile));
        }

        return packageRepository.save(gymPackage);
    }

    public GymPackage updatePackage(Integer id, GymPackage formPackage, MultipartFile imageFile) {
        Optional<GymPackage> optional = packageRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        GymPackage existing = optional.get();
        existing.setPackageName(formPackage.getPackageName());
        existing.setPrice(formPackage.getPrice());
        existing.setDurationDays(formPackage.getDurationDays());
        existing.setDescription(formPackage.getDescription());
        existing.setStatus(formPackage.getStatus());

        if (imageFile != null && !imageFile.isEmpty()) {
            existing.setImage(saveImage(imageFile));
        }

        return packageRepository.save(existing);
    }

    public boolean softDeletePackage(Integer id) {
        Optional<GymPackage> optional = packageRepository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        GymPackage gymPackage = optional.get();
        gymPackage.setStatus(0);
        packageRepository.save(gymPackage);
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