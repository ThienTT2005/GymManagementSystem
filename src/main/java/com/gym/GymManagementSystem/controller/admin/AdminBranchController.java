//package com.gym.GymManagementSystem.controller.admin;
//
//import com.gym.GymManagementSystem.model.Club;
//import com.gym.GymManagementSystem.service.ClubService;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//@Controller
//@RequestMapping("/admin/branches")
//public class AdminBranchController {
//
//    private final ClubService clubService;
//
//    public AdminBranchController(ClubService clubService) {
//        this.clubService = clubService;
//    }
//
//    @GetMapping
//    public String listBranches(Model model) {
//        model.addAttribute("pageTitle", "Quản lý chi nhánh");
//        model.addAttribute("branches", clubService.findAll());
//        return "admin/branches/list";
//    }
//
//    @GetMapping("/create")
//    public String showCreateForm(Model model) {
//        model.addAttribute("pageTitle", "Thêm chi nhánh");
//        model.addAttribute("club", new Club());
//        return "admin/branches/form";
//    }
//
//    @PostMapping("/save")
//    public String saveBranch(@ModelAttribute("club") Club club) {
//        clubService.save(club);
//        return "redirect:/admin/branches";
//    }
//
//    @GetMapping("/edit/{id}")
//    public String showEditForm(@PathVariable Long id, Model model) {
//        Club club = clubService.findById(id);
//        model.addAttribute("pageTitle", "Sửa chi nhánh");
//        model.addAttribute("club", club);
//        return "admin/branches/form";
//    }
//
//    @GetMapping("/delete/{id}")
//    public String deleteBranch(@PathVariable Long id) {
//        clubService.deleteById(id);
//        return "redirect:/admin/branches";
//    }
//}