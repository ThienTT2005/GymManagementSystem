package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.service.ScheduleService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/schedules")
public class AdminScheduleController {

    private final ScheduleService scheduleService;

    public AdminScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String dayOfWeek,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Schedule> schedulePage = scheduleService.searchSchedules(keyword, dayOfWeek, page, size);

        model.addAttribute("pageTitle", "Quản lý lịch học");
        model.addAttribute("activePage", "schedules");
        model.addAttribute("keyword", keyword);
        model.addAttribute("dayOfWeek", dayOfWeek);
        model.addAttribute("schedulePage", schedulePage);

        return "admin/schedules/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Schedule schedule = new Schedule();
        schedule.setStatus(1);

        model.addAttribute("pageTitle", "Thêm lịch học");
        model.addAttribute("activePage", "schedules");
        model.addAttribute("schedule", schedule);
        model.addAttribute("classes", scheduleService.getAllClasses());
        model.addAttribute("isEdit", false);

        return "admin/schedules/form";
    }

    @PostMapping("/create")
    public String create(
            @Valid @ModelAttribute("schedule") Schedule schedule,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer classId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (classId == null) {
            bindingResult.reject("classId", "Vui lòng chọn lớp học");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm lịch học");
            model.addAttribute("activePage", "schedules");
            model.addAttribute("classes", scheduleService.getAllClasses());
            model.addAttribute("isEdit", false);
            return "admin/schedules/form";
        }

        scheduleService.createSchedule(schedule, classId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm lịch học thành công");
        return "redirect:/admin/schedules";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lịch học");
            return "redirect:/admin/schedules";
        }

        model.addAttribute("pageTitle", "Cập nhật lịch học");
        model.addAttribute("activePage", "schedules");
        model.addAttribute("schedule", schedule);
        model.addAttribute("classes", scheduleService.getAllClasses());
        model.addAttribute("isEdit", true);

        return "admin/schedules/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Integer id,
            @Valid @ModelAttribute("schedule") Schedule schedule,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer classId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (classId == null) {
            bindingResult.reject("classId", "Vui lòng chọn lớp học");
        }

        if (bindingResult.hasErrors()) {
            schedule.setScheduleId(id);
            model.addAttribute("pageTitle", "Cập nhật lịch học");
            model.addAttribute("activePage", "schedules");
            model.addAttribute("classes", scheduleService.getAllClasses());
            model.addAttribute("isEdit", true);
            return "admin/schedules/form";
        }

        Schedule updated = scheduleService.updateSchedule(id, schedule, classId);
        if (updated == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lịch học");
            return "redirect:/admin/schedules";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật lịch học thành công");
        return "redirect:/admin/schedules";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        Schedule schedule = scheduleService.getScheduleById(id);

        if (schedule == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lịch học");
            return "redirect:/admin/schedules";
        }

        int newStatus = (schedule.getStatus() != null && schedule.getStatus() == 1) ? 0 : 1;
        scheduleService.updateStatus(id, newStatus);

        redirectAttributes.addFlashAttribute(
                "successMessage",
                newStatus == 1 ? "Kích hoạt lịch học thành công" : "Ngừng hoạt động lịch học thành công"
        );

        return "redirect:/admin/schedules";
    }
}