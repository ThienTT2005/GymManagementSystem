package com.gym.GymManagementSystem.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor  // Lombok tạo constructor có tham số
public class ScheduleDTO {
    private Schedule schedule;
    private long registeredCount;
}