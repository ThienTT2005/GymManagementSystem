package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.Membership;
import com.gym.GymManagementSystem.repository.MembershipRepository;
import com.gym.GymManagementSystem.service.MembershipService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class MembershipServiceImpl implements MembershipService {

    private final MembershipRepository membershipRepository;

    public MembershipServiceImpl(MembershipRepository membershipRepository) {
        this.membershipRepository = membershipRepository;
    }

    @Override
    public List<Membership> findAll() {
        List<Membership> list = membershipRepository.findAll();

        LocalDate today = LocalDate.now();

        for (Membership m : list) {
            if (m.getEndDate() != null && m.getEndDate().isBefore(today)) {
                if (!"Hết hạn".equalsIgnoreCase(m.getStatus())) {
                    m.setStatus("Hết hạn");
                    membershipRepository.save(m);
                }
            }
        }

        return list;
    }

    @Override
    public Membership findById(Long id) {
        return membershipRepository.findById(id).orElse(null);
    }

    @Override
    public Membership save(Membership membership) {
        return membershipRepository.save(membership);
    }

    @Override
    public void deleteById(Long id) {
        membershipRepository.deleteById(id);
    }

    @Override
    public void toggleStatus(Long id) {
        Membership membership = membershipRepository.findById(id).orElse(null);
        if (membership != null) {
            if ("Đang hoạt động".equalsIgnoreCase(membership.getStatus())) {
                membership.setStatus("Tạm dừng");
            } else {
                membership.setStatus("Đang hoạt động");
            }
            membershipRepository.save(membership);
        }
    }

    @Override
    public Page<Membership> searchMemberships(String keyword, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("memberName").ascending());

        Page<Membership> pageData = membershipRepository.searchMemberships(keyword, status, pageable);

        LocalDate today = LocalDate.now();

        for (Membership m : pageData.getContent()) {
            if (m.getEndDate() != null && m.getEndDate().isBefore(today)) {
                if (!"Hết hạn".equalsIgnoreCase(m.getStatus())) {
                    m.setStatus("Hết hạn");
                    membershipRepository.save(m);
                }
            }
        }

        return pageData;
    }
}