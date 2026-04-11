package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.service.GymClassService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/classes")
public class AdminClassController {

    private final GymClassService gymClassService;

    public AdminClassController(GymClassService gymClassService) {
        this.gymClassService = gymClassService;
    }

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Integer serviceId,
            @RequestParam(required = false) Integer trainerId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<GymClass> classPage = gymClassService.searchClasses(keyword, serviceId, trainerId, status, page, size);

        model.addAttribute("pageTitle", "Quản lý lớp học");
        model.addAttribute("activePage", "classes");
        model.addAttribute("keyword", keyword);
        model.addAttribute("serviceId", serviceId);
        model.addAttribute("trainerId", trainerId);
        model.addAttribute("status", status);
        model.addAttribute("classPage", classPage);
        model.addAttribute("services", gymClassService.getAllServices());
        model.addAttribute("trainers", gymClassService.getAllTrainers());

        return "admin/classes/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        GymClass gymClass = new GymClass();
        gymClass.setStatus(1);
        gymClass.setCurrentMember(0);

        model.addAttribute("pageTitle", "Thêm lớp học");
        model.addAttribute("activePage", "classes");
        model.addAttribute("gymClass", gymClass);
        model.addAttribute("services", gymClassService.getAllServices());
        model.addAttribute("trainers", gymClassService.getAllTrainers());
        model.addAttribute("isEdit", false);
        model.addAttribute("viewOnly", false);

        return "admin/classes/form";
    }

    @PostMapping("/create")
    public String create(
            @Valid @ModelAttribute("gymClass") GymClass gymClass,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer serviceId,
            @RequestParam(required = false) Integer trainerId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (serviceId == null) {
            bindingResult.reject("serviceId", "Vui lòng chọn dịch vụ");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm lớp học");
            model.addAttribute("activePage", "classes");
            model.addAttribute("services", gymClassService.getAllServices());
            model.addAttribute("trainers", gymClassService.getAllTrainers());
            model.addAttribute("isEdit", false);
            model.addAttribute("viewOnly", false);
            return "admin/classes/form";
        }

        gymClassService.createClass(gymClass, serviceId, trainerId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm lớp học thành công");
        return "redirect:/admin/classes";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        GymClass gymClass = gymClassService.getClassById(id);
        if (gymClass == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lớp học");
            return "redirect:/admin/classes";
        }

        model.addAttribute("pageTitle", "Cập nhật lớp học");
        model.addAttribute("activePage", "classes");
        model.addAttribute("gymClass", gymClass);
        model.addAttribute("services", gymClassService.getAllServices());
        model.addAttribute("trainers", gymClassService.getAllTrainers());
        model.addAttribute("isEdit", true);
        model.addAttribute("viewOnly", false);

        return "admin/classes/form";
    }

    @GetMapping({"/detail/{id}", "/{id}"})
    public String showDetail(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        GymClass gymClass = gymClassService.getClassById(id);
        if (gymClass == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lớp học");
            return "redirect:/admin/classes";
        }

        model.addAttribute("pageTitle", "Chi tiết lớp học");
        model.addAttribute("activePage", "classes");
        model.addAttribute("gymClass", gymClass);
        model.addAttribute("memberCount", gymClassService.countActiveMembersByClassId(id));
        model.addAttribute("schedules", gymClassService.getSchedulesByClassId(id));

        return "admin/classes/detail";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Integer id,
            @Valid @ModelAttribute("gymClass") GymClass gymClass,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer serviceId,
            @RequestParam(required = false) Integer trainerId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (serviceId == null) {
            bindingResult.reject("serviceId", "Vui lòng chọn dịch vụ");
        }

        if (bindingResult.hasErrors()) {
            gymClass.setClassId(id);
            model.addAttribute("pageTitle", "Cập nhật lớp học");
            model.addAttribute("activePage", "classes");
            model.addAttribute("services", gymClassService.getAllServices());
            model.addAttribute("trainers", gymClassService.getAllTrainers());
            model.addAttribute("isEdit", true);
            model.addAttribute("viewOnly", false);
            return "admin/classes/form";
        }

        GymClass updated = gymClassService.updateClass(id, gymClass, serviceId, trainerId);
        if (updated == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lớp học");
            return "redirect:/admin/classes";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật lớp học thành công");
        return "redirect:/admin/classes";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        GymClass gymClass = gymClassService.getClassById(id);

        if (gymClass == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lớp học");
            return "redirect:/admin/classes";
        }

        int newStatus = (gymClass.getStatus() != null && gymClass.getStatus() == 1) ? 0 : 1;
        gymClassService.updateStatus(id, newStatus);

        redirectAttributes.addFlashAttribute(
                "successMessage",
                newStatus == 1 ? "Kích hoạt lớp học thành công" : "Ngừng hoạt động lớp học thành công"
        );

        return "redirect:/admin/classes";
    }
}