package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.GymService;
import com.gym.GymManagementSystem.service.GymServiceService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/services")
public class AdminServiceController {

    private final GymServiceService gymServiceService;

    public AdminServiceController(GymServiceService gymServiceService) {
        this.gymServiceService = gymServiceService;
    }

    @GetMapping
    public String listServices(Model model) {
        model.addAttribute("pageTitle", "Quản lý dịch vụ");
        model.addAttribute("services", gymServiceService.findAll());
        return "admin/services/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("pageTitle", "Thêm dịch vụ");
        model.addAttribute("gymService", new GymService());
        return "admin/services/form";
    }

    @PostMapping("/save")
    public String saveService(@ModelAttribute("gymService") GymService gymService) {
        gymServiceService.save(gymService);
        return "redirect:/admin/services";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        GymService gymService = gymServiceService.findById(id);
        model.addAttribute("pageTitle", "Sửa dịch vụ");
        model.addAttribute("gymService", gymService);
        return "admin/services/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteService(@PathVariable Long id) {
        gymServiceService.deleteById(id);
        return "redirect:/admin/services";
    }
}