package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Integer> {
    Optional<Member> findByUserUserId(Integer userId);
}