package com.gym.GymManagementSystem;

import com.gym.GymManagementSystem.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class GymManagementSystemApplicationTests {

    @Autowired
    private UserRepository userRepository;

    @Test
    void testDB() {
        System.out.println(userRepository.findAll());
    }
}