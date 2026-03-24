package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.Membership;
import org.springframework.data.domain.Page;

import java.util.List;

public interface MembershipService {
    List<Membership> findAll();
    Membership findById(Long id);
    Membership save(Membership membership);
    void deleteById(Long id);
    void toggleStatus(Long id);
    Page<Membership> searchMemberships(String keyword, String status, int page, int size);
}