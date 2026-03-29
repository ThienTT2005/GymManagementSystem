package com.gym.service;

import com.gym.model.Role;
import com.gym.model.User;
import com.gym.repository.RoleRepository;
import com.gym.repository.UserRepository;
import com.gym.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private RoleRepository roleRepo;

    public User login(String username, String password) {

        User user = userRepo.findByUsername(username);

        System.out.println("USER: " + user);

        if (user == null) {
            return null;
        }

        System.out.println("INPUT PASS: " + password);
        System.out.println("DB PASS: " + user.getPassword());

        boolean check = PasswordUtil.check(password, user.getPassword());
        System.out.println("CHECK: " + check);

        if (!check) {
            return null;
        }

        if (!"Active".equalsIgnoreCase(user.getStatus())) {
            return null;
        }

        return user;
    }

    public void register(String username, String password, String fullName) {

        if (userRepo.findByUsername(username) != null) {
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hash(password));
        user.setFullName(fullName);
        user.setStatus("Active");

        Role role = roleRepo.findByRoleName("Member");
        user.setRole(role);

        userRepo.save(user);
    }
}
