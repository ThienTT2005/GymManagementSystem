package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.GymPackage;
import com.gym.GymManagementSystem.service.GymPackageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/packages")
public class AdminPackageController {

    private final GymPackageService gymPackageService;

    public AdminPackageController(GymPackageService gymPackageService) {
        this.gymPackageService = gymPackageService;
    }

    @GetMapping
    public String listPackages(Model model) {
        model.addAttribute("pageTitle", "Quản lý gói tập");
        model.addAttribute("packages", gymPackageService.findAll());
        return "admin/packages/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("pageTitle", "Thêm gói tập");
        model.addAttribute("gymPackage", new GymPackage());
        return "admin/packages/form";
    }

    @PostMapping("/save")
    public String savePackage(@ModelAttribute("gymPackage") GymPackage gymPackage) {
        gymPackageService.save(gymPackage);
        return "redirect:/admin/packages";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        GymPackage gymPackage = gymPackageService.findById(id);
        model.addAttribute("pageTitle", "Sửa gói tập");
        model.addAttribute("gymPackage", gymPackage);
        return "admin/packages/form";
    }

    @GetMapping("/delete/{id}")
    public String deletePackage(@PathVariable Long id) {
        gymPackageService.deleteById(id);
        return "redirect:/admin/packages";
    }
}