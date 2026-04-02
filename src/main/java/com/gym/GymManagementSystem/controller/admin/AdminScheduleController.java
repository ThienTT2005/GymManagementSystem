package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.Schedule;
import com.gym.GymManagementSystem.service.ScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/schedules")
public class AdminScheduleController {

    private final ScheduleService scheduleService;

    public AdminScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @GetMapping
    public String listSchedules(Model model) {
        model.addAttribute("pageTitle", "Quản lý lịch tập");
        model.addAttribute("schedules", scheduleService.findAll());
        return "admin/schedules/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Schedule schedule = new Schedule();
        schedule.setScheduleDate(LocalDate.now());
        schedule.setStatus("Đang mở");

        model.addAttribute("pageTitle", "Thêm lịch tập");
        model.addAttribute("schedule", schedule);
        return "admin/schedules/form";
    }

    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute("schedule") Schedule schedule) {
        if (schedule.getScheduleDate() == null) {
            schedule.setScheduleDate(LocalDate.now());
        }
        if (schedule.getStatus() == null || schedule.getStatus().isBlank()) {
            schedule.setStatus("Đang mở");
        }
        scheduleService.save(schedule);
        return "redirect:/admin/schedules";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Schedule schedule = scheduleService.findById(id);
        model.addAttribute("pageTitle", "Sửa lịch tập");
        model.addAttribute("schedule", schedule);
        return "admin/schedules/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteSchedule(@PathVariable Long id) {
        scheduleService.deleteById(id);
        return "redirect:/admin/schedules";
    }
}