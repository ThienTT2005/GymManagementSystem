package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NewsRepository newsRepository;

    @GetMapping("/check-phone")
    public ResponseEntity<Boolean> checkPhone(@RequestParam String phone) {
        return ResponseEntity.ok(userRepository.existsByPhone(phone));
    }
}
