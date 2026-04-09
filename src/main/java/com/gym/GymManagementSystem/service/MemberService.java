package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MemberService {

    private final MemberRepository memberRepository;
    private final UserRepository userRepository;

    public MemberService(MemberRepository memberRepository,
                         UserRepository userRepository) {
        this.memberRepository = memberRepository;
        this.userRepository = userRepository;
    }

    public Page<Member> searchMembers(String keyword, Integer status, int page, int size) {
        PageRequest pageable = PageRequest.of(Math.max(page - 1, 0), size, Sort.by(Sort.Direction.DESC, "memberId"));
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null;

        if (hasKeyword && hasStatus) {
            return memberRepository.findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCaseAndStatus(
                    keyword.trim(), keyword.trim(), keyword.trim(), status, pageable
            );
        }

        if (hasKeyword) {
            return memberRepository.findByFullnameContainingIgnoreCaseOrPhoneContainingIgnoreCaseOrEmailContainingIgnoreCase(
                    keyword.trim(), keyword.trim(), keyword.trim(), pageable
            );
        }

        if (hasStatus) {
            return memberRepository.findByStatus(status, pageable);
        }

        return memberRepository.findAll(pageable);
    }

    public long countMembers() {
        return memberRepository.count();
    }

    public Member getMemberById(Integer id) {
        return memberRepository.findById(id).orElse(null);
    }

    public Member createMember(Member member, Integer userId) {
        bindUser(member, userId);
        if (member.getStatus() == null) {
            member.setStatus(1);
        }
        return memberRepository.save(member);
    }

    public Member updateMember(Integer id, Member formMember, Integer userId) {
        Optional<Member> optional = memberRepository.findById(id);
        if (optional.isEmpty()) {
            return null;
        }

        Member existing = optional.get();
        existing.setFullname(formMember.getFullname());
        existing.setPhone(formMember.getPhone());
        existing.setEmail(formMember.getEmail());
        existing.setAddress(formMember.getAddress());
        existing.setGender(formMember.getGender());
        existing.setDob(formMember.getDob());
        existing.setStatus(formMember.getStatus());

        bindUser(existing, userId);
        return memberRepository.save(existing);
    }

    public boolean existsByUserId(Integer userId, Integer excludeMemberId) {
        if (userId == null) {
            return false;
        }
        if (excludeMemberId == null) {
            return memberRepository.existsByUser_UserId(userId);
        }
        return memberRepository.existsByUser_UserIdAndMemberIdNot(userId, excludeMemberId);
    }

    public boolean softDeleteMember(Integer id) {
        return memberRepository.findById(id).map(existing -> {
            existing.setStatus(0);
            memberRepository.save(existing);
            return true;
        }).orElse(false);
    }

    public List<User> getAssignableUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username")).stream()
                .filter(u -> "MEMBER".equalsIgnoreCase(u.getRoleName()))
                .filter(u -> !memberRepository.existsByUser_UserId(u.getUserId()))
                .toList();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "username"));
    }

    private void bindUser(Member member, Integer userId) {
        if (userId == null) {
            member.setUser(null);
            return;
        }

        User user = userRepository.findById(userId).orElse(null);
        member.setUser(user);
    }
}