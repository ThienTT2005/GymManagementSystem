package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.service.PackageService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/packages")
public class AdminPackageController {

    private final PackageService packageService;

    public AdminPackageController(PackageService packageService) {
        this.packageService = packageService;
    }

    @GetMapping
    public String listPackages(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<GymPackage> packagePage = packageService.searchPackages(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý gói tập");
        model.addAttribute("activePage", "packages");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("packagePage", packagePage);

        return "admin/packages/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        GymPackage gymPackage = new GymPackage();
        gymPackage.setStatus(1);

        model.addAttribute("pageTitle", "Thêm gói tập");
        model.addAttribute("activePage", "packages");
        model.addAttribute("gymPackage", gymPackage);
        model.addAttribute("isEdit", false);

        return "admin/packages/form";
    }

    @PostMapping("/create")
    public String createPackage(
            @Valid @ModelAttribute("gymPackage") GymPackage gymPackage,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (packageService.existsByPackageName(gymPackage.getPackageName(), null)) {
            bindingResult.rejectValue("packageName", "error.packageName", "Tên gói tập đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm gói tập");
            model.addAttribute("activePage", "packages");
            model.addAttribute("isEdit", false);
            return "admin/packages/form";
        }

        packageService.createPackage(gymPackage, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm gói tập thành công");
        return "redirect:/admin/packages";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        GymPackage gymPackage = packageService.getPackageById(id);
        if (gymPackage == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy gói tập");
            return "redirect:/admin/packages";
        }

        model.addAttribute("pageTitle", "Cập nhật gói tập");
        model.addAttribute("activePage", "packages");
        model.addAttribute("gymPackage", gymPackage);
        model.addAttribute("isEdit", true);

        return "admin/packages/form";
    }

    @PostMapping("/edit/{id}")
    public String updatePackage(
            @PathVariable Integer id,
            @Valid @ModelAttribute("gymPackage") GymPackage gymPackage,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (packageService.getPackageById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy gói tập");
            return "redirect:/admin/packages";
        }

        if (packageService.existsByPackageName(gymPackage.getPackageName(), id)) {
            bindingResult.rejectValue("packageName", "error.packageName", "Tên gói tập đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            gymPackage.setPackageId(id);
            model.addAttribute("pageTitle", "Cập nhật gói tập");
            model.addAttribute("activePage", "packages");
            model.addAttribute("isEdit", true);
            return "admin/packages/form";
        }

        packageService.updatePackage(id, gymPackage, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật gói tập thành công");
        return "redirect:/admin/packages";
    }

    @PostMapping("/delete/{id}")
    public String deletePackage(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = packageService.softDeletePackage(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Xóa gói tập thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy gói tập");
        }

        return "redirect:/admin/packages";
    }
}