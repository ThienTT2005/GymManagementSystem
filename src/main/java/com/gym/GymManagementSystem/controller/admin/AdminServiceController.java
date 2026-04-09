package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.service.ServiceGymService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/services")
public class AdminServiceController {

    private final ServiceGymService serviceGymService;

    public AdminServiceController(ServiceGymService serviceGymService) {
        this.serviceGymService = serviceGymService;
    }

    @GetMapping
    public String listServices(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<ServiceGym> servicePage = serviceGymService.searchServices(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý dịch vụ");
        model.addAttribute("activePage", "services");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("servicePage", servicePage);

        return "admin/services/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        ServiceGym serviceGym = new ServiceGym();
        serviceGym.setStatus(1);

        model.addAttribute("pageTitle", "Thêm dịch vụ");
        model.addAttribute("activePage", "services");
        model.addAttribute("serviceGym", serviceGym);
        model.addAttribute("isEdit", false);

        return "admin/services/form";
    }

    @PostMapping("/create")
    public String createService(
            @Valid @ModelAttribute("serviceGym") ServiceGym serviceGym,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (serviceGymService.existsByServiceName(serviceGym.getServiceName(), null)) {
            bindingResult.rejectValue("serviceName", "error.serviceName", "Tên dịch vụ đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm dịch vụ");
            model.addAttribute("activePage", "services");
            model.addAttribute("isEdit", false);
            return "admin/services/form";
        }

        serviceGymService.createService(serviceGym, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm dịch vụ thành công");
        return "redirect:/admin/services";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        ServiceGym serviceGym = serviceGymService.getServiceById(id);
        if (serviceGym == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }

        model.addAttribute("pageTitle", "Cập nhật dịch vụ");
        model.addAttribute("activePage", "services");
        model.addAttribute("serviceGym", serviceGym);
        model.addAttribute("isEdit", true);

        return "admin/services/form";
    }

    @PostMapping("/edit/{id}")
    public String updateService(
            @PathVariable Integer id,
            @Valid @ModelAttribute("serviceGym") ServiceGym serviceGym,
            BindingResult bindingResult,
            @RequestParam("imageFile") MultipartFile imageFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (serviceGymService.getServiceById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }

        if (serviceGymService.existsByServiceName(serviceGym.getServiceName(), id)) {
            bindingResult.rejectValue("serviceName", "error.serviceName", "Tên dịch vụ đã tồn tại");
        }

        if (bindingResult.hasErrors()) {
            serviceGym.setServiceId(id);
            model.addAttribute("pageTitle", "Cập nhật dịch vụ");
            model.addAttribute("activePage", "services");
            model.addAttribute("isEdit", true);
            return "admin/services/form";
        }

        serviceGymService.updateService(id, serviceGym, imageFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật dịch vụ thành công");
        return "redirect:/admin/services";
    }

    @PostMapping("/delete/{id}")
    public String deleteService(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = serviceGymService.softDeleteService(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Xóa dịch vụ thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy dịch vụ");
        }

        return "redirect:/admin/services";
    }
}