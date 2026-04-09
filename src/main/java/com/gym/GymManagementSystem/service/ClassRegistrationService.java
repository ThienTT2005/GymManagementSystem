package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.repository.ClassRegistrationRepository;
import com.gym.GymManagementSystem.repository.GymClassRepository;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClassRegistrationService {

    private final ClassRegistrationRepository repository;
    private final MemberRepository memberRepository;
    private final GymClassRepository gymClassRepository;
    private final ServiceRepository serviceRepository;

    public ClassRegistrationService(ClassRegistrationRepository repository,
                                    MemberRepository memberRepository,
                                    GymClassRepository gymClassRepository,
                                    ServiceRepository serviceRepository) {
        this.repository = repository;
        this.memberRepository = memberRepository;
        this.gymClassRepository = gymClassRepository;
        this.serviceRepository = serviceRepository;
    }

    public Page<ClassRegistration> searchRegistrations(String keyword, String status, Integer classId, int page, int size) {
        PageRequest pageable = PageRequest.of(
                Math.max(page - 1, 0),
                size,
                Sort.by(Sort.Direction.DESC, "registrationId")
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();
        boolean hasClass = classId != null;
        String kw = hasKeyword ? keyword.trim() : "";

        if (hasKeyword && hasClass && hasStatus) {
            return repository.findByMember_FullnameContainingIgnoreCaseAndGymClass_ClassIdAndStatus(
                    kw, classId, status.trim(), pageable
            );
        }

        if (hasKeyword && hasStatus) {
            return repository.findByMember_FullnameContainingIgnoreCaseAndStatus(
                    kw, status.trim(), pageable
            );
        }

        if (hasClass && hasStatus) {
            return repository.findByGymClass_ClassIdAndStatus(
                    classId, status.trim(), pageable
            );
        }

        if (hasKeyword) {
            return repository.findByMember_FullnameContainingIgnoreCase(kw, pageable);
        }

        if (hasClass) {
            return repository.findByGymClass_ClassId(classId, pageable);
        }

        if (hasStatus) {
            return repository.findByStatus(status.trim(), pageable);
        }

        return repository.findAll(pageable);
    }

    public ClassRegistration getRegistrationById(Integer id) {
        return repository.findById(id).orElse(null);
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll(Sort.by(Sort.Direction.ASC, "fullname"));
    }

    public List<GymClass> getAllClasses() {
        return gymClassRepository.findAll(Sort.by(Sort.Direction.ASC, "className"));
    }

    public List<ServiceGym> getAllServices() {
        return serviceRepository.findAll(Sort.by(Sort.Direction.ASC, "serviceName"));
    }

    public ClassRegistration createRegistration(ClassRegistration registration, Integer memberId, Integer classId, Integer serviceId) {
        bindRelations(registration, memberId, classId, serviceId);
        validateDates(registration);

        if (registration.getStatus() == null || registration.getStatus().isBlank()) {
            registration.setStatus("PENDING");
        }

        return repository.save(registration);
    }

    public ClassRegistration updateRegistration(Integer id, ClassRegistration formRegistration, Integer memberId, Integer classId, Integer serviceId) {
        Optional<ClassRegistration> optional = repository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        ClassRegistration existing = optional.get();
        existing.setStartDate(formRegistration.getStartDate());
        existing.setEndDate(formRegistration.getEndDate());
        existing.setRegistrationDate(formRegistration.getRegistrationDate());
        existing.setStatus(formRegistration.getStatus());
        existing.setNote(formRegistration.getNote());

        bindRelations(existing, memberId, classId, serviceId);
        validateDates(existing);

        return repository.save(existing);
    }

    public boolean cancelRegistration(Integer id) {
        Optional<ClassRegistration> optional = repository.findById(id);
        if (optional.isEmpty()) {
            return false;
        }

        ClassRegistration registration = optional.get();
        registration.setStatus("CANCELLED");
        repository.save(registration);
        return true;
    }

    public List<ClassRegistration> findAll() {
        return repository.findAll(Sort.by(Sort.Direction.DESC, "registrationId"));
    }

    public long countActive() {
        return repository.countByStatus("ACTIVE");
    }

    public long countPending() {
        return repository.countByStatus("PENDING");
    }

    public List<ClassRegistration> findPending() {
        return repository.findByStatus("PENDING", PageRequest.of(0, 5)).getContent();
    }

    public List<ClassRegistration> findActiveByClassId(Integer classId) {
        return repository.findByGymClass_ClassIdAndStatus(classId, "ACTIVE");
    }

    public void approve(int id) {
        repository.findById(id).ifPresent(registration -> {
            registration.setStatus("ACTIVE");
            repository.save(registration);
        });
    }

    public void reject(int id) {
        repository.findById(id).ifPresent(registration -> {
            registration.setStatus("REJECTED");
            repository.save(registration);
        });
    }

    private void bindRelations(ClassRegistration registration, Integer memberId, Integer classId, Integer serviceId) {
        Member member = memberId != null ? memberRepository.findById(memberId).orElse(null) : null;
        GymClass gymClass = classId != null ? gymClassRepository.findById(classId).orElse(null) : null;
        ServiceGym service = serviceId != null ? serviceRepository.findById(serviceId).orElse(null) : null;

        registration.setMember(member);
        registration.setGymClass(gymClass);
        registration.setService(service);
    }

    private void validateDates(ClassRegistration registration) {
        if (registration.getStartDate() != null
                && registration.getEndDate() != null
                && registration.getEndDate().isBefore(registration.getStartDate())) {
            throw new IllegalArgumentException("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }
    }
}