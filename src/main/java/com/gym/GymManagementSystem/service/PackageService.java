package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.repository.PackageRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Comparator;
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
        int safePage = Math.max(page - 1, 0);
        int safeSize = size > 0 ? size : 8;
        String normalizedKeyword = trimToNull(keyword);

        PageRequest pageable = PageRequest.of(safePage, safeSize);

        boolean hasKeyword = normalizedKeyword != null;
        boolean hasStatus = status != null;

        Page<GymPackage> rawPage;

        if (hasKeyword && hasStatus) {
            rawPage = packageRepository.findByPackageNameContainingIgnoreCaseAndStatus(normalizedKeyword, status, pageable);
        } else if (hasKeyword) {
            rawPage = packageRepository.findByPackageNameContainingIgnoreCase(normalizedKeyword, pageable);
        } else if (hasStatus) {
            rawPage = packageRepository.findByStatus(status, pageable);
        } else {
            rawPage = packageRepository.findAll(pageable);
        }

        List<GymPackage> sortedContent = rawPage.getContent().stream()
                .sorted(packageDurationComparator())
                .toList();

        return new PageImpl<>(sortedContent, pageable, rawPage.getTotalElements());
    }

    public List<GymPackage> getAllPackages() {
        return packageRepository.findAll().stream()
                .sorted(packageDurationComparator())
                .toList();
    }

    public GymPackage getPackageById(Integer id) {
        if (id == null) return null;
        return packageRepository.findById(id).orElse(null);
    }

    public boolean existsByPackageName(String packageName, Integer excludeId) {
        String normalizedName = trimToNull(packageName);
        if (normalizedName == null) return false;

        if (excludeId == null) {
            return packageRepository.existsByPackageNameIgnoreCase(normalizedName);
        }

        return packageRepository.existsByPackageNameIgnoreCaseAndPackageIdNot(normalizedName, excludeId);
    }

    public GymPackage createPackage(GymPackage gymPackage, MultipartFile imageFile) {
        if (gymPackage == null) {
            throw new IllegalArgumentException("Thông tin gói tập không hợp lệ");
        }

        normalizePackage(gymPackage);
        validatePackage(gymPackage);

        if (gymPackage.getStatus() == null) {
            gymPackage.setStatus(1);
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            gymPackage.setImage(saveImage(imageFile));
        }

        return packageRepository.save(gymPackage);
    }

    public GymPackage updatePackage(Integer id, GymPackage formPackage, MultipartFile imageFile) {
        if (id == null || formPackage == null) {
            throw new IllegalArgumentException("Thông tin cập nhật không hợp lệ");
        }

        Optional<GymPackage> optional = packageRepository.findById(id);
        if (optional.isEmpty()) return null;

        GymPackage existing = optional.get();

        normalizePackage(formPackage);
        validatePackage(formPackage);

        existing.setPackageName(formPackage.getPackageName());
        existing.setPrice(formPackage.getPrice());
        existing.setDurationMonths(formPackage.getDurationMonths());
        existing.setDescription(formPackage.getDescription());
        existing.setStatus(formPackage.getStatus());

        if (imageFile != null && !imageFile.isEmpty()) {
            existing.setImage(saveImage(imageFile));
        }

        return packageRepository.save(existing);
    }

    public boolean deletePackage(Integer id) {
        return softDeletePackage(id);
    }

    public boolean softDeletePackage(Integer id) {
        Optional<GymPackage> optional = packageRepository.findById(id);
        if (optional.isEmpty()) return false;

        GymPackage gymPackage = optional.get();
        gymPackage.setStatus(0);
        packageRepository.save(gymPackage);
        return true;
    }

    public void updateStatus(Integer id, Integer status) {
        if (id == null) throw new IllegalArgumentException("Không tìm thấy gói tập");

        if (status == null || (status != 0 && status != 1)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }

        GymPackage gymPackage = packageRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói tập"));

        gymPackage.setStatus(status);
        packageRepository.save(gymPackage);
    }

    private Comparator<GymPackage> packageDurationComparator() {
        return Comparator
                .comparing(GymPackage::getDurationMonths, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(pkg -> pkg.getPackageName() == null ? "" : pkg.getPackageName().trim().toLowerCase())
                .thenComparing(GymPackage::getPackageId, Comparator.nullsLast(Comparator.reverseOrder()));
    }

    private void normalizePackage(GymPackage gymPackage) {
        gymPackage.setPackageName(trimToNull(gymPackage.getPackageName()));
        gymPackage.setDescription(trimToNull(gymPackage.getDescription()));
    }

    private void validatePackage(GymPackage gymPackage) {
        if (gymPackage.getPackageName() == null) {
            throw new IllegalArgumentException("Tên gói tập không được để trống");
        }

        if (gymPackage.getPrice() == null) {
            throw new IllegalArgumentException("Giá gói tập không được để trống");
        }

        if (gymPackage.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Giá gói tập phải lớn hơn 0");
        }

        if (gymPackage.getDurationMonths() == null || gymPackage.getDurationMonths() <= 0) {
            throw new IllegalArgumentException("Thời hạn gói tập phải lớn hơn 0");
        }

        if (gymPackage.getStatus() == null) {
            gymPackage.setStatus(1);
        }

        if (gymPackage.getStatus() != 0 && gymPackage.getStatus() != 1) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ");
        }
    }

    // ✅ FIX 100% lỗi 500
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

            Files.copy(
                    imageFile.getInputStream(),
                    destination,
                    StandardCopyOption.REPLACE_EXISTING
            );

        } catch (IOException e) {
            throw new RuntimeException("Không thể upload ảnh", e);
        }

        return fileName;
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}