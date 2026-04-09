package com.gym.GymManagementSystem.repository;

import com.gym.GymManagementSystem.model.ClassMember;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClassMemberRepository extends JpaRepository<ClassMember, Integer> {

    List<ClassMember> findByGymClass_ClassId(Integer classId);

    long countByGymClass_ClassId(Integer classId);

    boolean existsByGymClass_ClassIdAndMember_MemberId(Integer classId, Integer memberId);
}