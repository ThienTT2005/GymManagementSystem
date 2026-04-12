package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.Member;
import com.gym.GymManagementSystem.entity.Staff;
import com.gym.GymManagementSystem.entity.User;
import com.gym.GymManagementSystem.repository.MemberRepository;
import com.gym.GymManagementSystem.repository.RoleRepository;
import com.gym.GymManagementSystem.repository.StaffRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import com.gym.GymManagementSystem.service.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final MemberRepository memberRepository;
    private final StaffRepository staffRepository;

    public UserServiceImpl(UserRepository userRepository,
                           RoleRepository roleRepository,
                           MemberRepository memberRepository,
                           StaffRepository staffRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.memberRepository = memberRepository;
        this.staffRepository = staffRepository;
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(Long id) {
        return userRepository.findByIdWithProfiles(id).orElse(null);
    }

    @Override
    @Transactional
    public User save(User user) {
        applyPendingRole(user);
        if (user.getRoleEntity() == null) {
            roleRepository.findByRoleNameIgnoreCase("MEMBER").ifPresent(user::setRoleEntity);
        }

        userRepository.save(user);
        syncProfileForRole(user);
        return userRepository.findByIdWithProfiles(user.getUserId()).orElse(user);
    }

    private void applyPendingRole(User user) {
        if (user.getPendingRoleName() != null && !user.getPendingRoleName().isBlank()) {
            roleRepository.findByRoleNameIgnoreCase(user.getPendingRoleName().trim())
                    .ifPresent(user::setRoleEntity);
        }
        user.setPendingRoleName(null);
    }

    private void syncProfileForRole(User user) {
        String roleName = user.getRole() != null ? user.getRole().toUpperCase() : "";
        String displayName = user.getFullName();
        String mail = user.getEmail();
        String tel = user.getPhone();
        String pic = user.getAvatar();

        if ("MEMBER".equals(roleName)) {
            Member member = memberRepository.findByUser_UserId(user.getUserId()).orElse(new Member());
            member.setUser(user);
            if (displayName != null && !displayName.isBlank()) {
                member.setFullname(displayName);
            } else if (member.getFullname() == null || member.getFullname().isBlank()) {
                member.setFullname(user.getUsername());
            }
            member.setEmail(mail);
            member.setPhone(tel);
            member.setAvatar(pic);
            if (member.getStatus() == null) {
                member.setStatus(1);
            }
            memberRepository.save(member);
        } else if ("STAFF".equals(roleName)) {
            Staff staff = staffRepository.findByUser_UserId(user.getUserId()).orElse(new Staff());
            staff.setUser(user);
            if (displayName != null && !displayName.isBlank()) {
                staff.setFullName(displayName);
            } else if (staff.getFullName() == null || staff.getFullName().isBlank()) {
                staff.setFullName(user.getUsername());
            }
            staff.setEmail(mail);
            staff.setPhone(tel);
            staff.setAvatar(pic);
            if (staff.getStatus() == null) {
                staff.setStatus(1);
            }
            staffRepository.save(staff);
        }
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public List<User> findByRole(String role) {
        return userRepository.findByRoleEntity_RoleNameIgnoreCase(role);
    }

    @Override
    public Page<User> searchUsers(String keyword, String role, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("username").ascending());
        return userRepository.searchUsers(keyword, role, status, pageable);
    }

    @Override
    @Transactional
    public void toggleStatus(Long id) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            if (user.getStatusCode() != null && user.getStatusCode() == 1) {
                user.setStatusCode(0);
            } else {
                user.setStatusCode(1);
            }
            userRepository.save(user);
        }
    }
}
