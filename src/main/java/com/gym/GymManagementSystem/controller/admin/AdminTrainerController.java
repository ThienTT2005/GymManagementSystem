package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.service.TrainerService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/trainers")
public class AdminTrainerController {

    private final TrainerService trainerService;

    public AdminTrainerController(TrainerService trainerService) {
        this.trainerService = trainerService;
    }

    @GetMapping
    public String listTrainers(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Trainer> trainerPage = trainerService.searchTrainers(keyword, status, page, size);

        model.addAttribute("pageTitle", "Quản lý huấn luyện viên");
        model.addAttribute("activePage", "trainers");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("trainerPage", trainerPage);

        return "admin/trainers/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Trainer trainer = new Trainer();
        trainer.setStatus(1);

        model.addAttribute("pageTitle", "Thêm huấn luyện viên");
        model.addAttribute("activePage", "trainers");
        model.addAttribute("trainer", trainer);
        model.addAttribute("staffs", trainerService.getAvailableStaffForTrainer());
        model.addAttribute("isEdit", false);

        return "admin/trainers/form";
    }

    @PostMapping("/create")
    public String createTrainer(
            @Valid @ModelAttribute("trainer") Trainer trainer,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer staffId,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (staffId == null) {
            bindingResult.reject("staffId", "Vui lòng chọn nhân viên");
        } else if (trainerService.existsByStaffId(staffId, null)) {
            bindingResult.reject("staffId", "Nhân viên này đã là huấn luyện viên");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm huấn luyện viên");
            model.addAttribute("activePage", "trainers");
            model.addAttribute("staffs", trainerService.getAvailableStaffForTrainer());
            model.addAttribute("isEdit", false);
            return "admin/trainers/form";
        }

        trainerService.createTrainer(trainer, staffId, photoFile);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm huấn luyện viên thành công");
        return "redirect:/admin/trainers";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Trainer trainer = trainerService.getTrainerById(id);
        if (trainer == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy huấn luyện viên");
            return "redirect:/admin/trainers";
        }

        model.addAttribute("pageTitle", "Cập nhật huấn luyện viên");
        model.addAttribute("activePage", "trainers");
        model.addAttribute("trainer", trainer);
        model.addAttribute("staffs", trainerService.getAvailableStaffForTrainer());
        model.addAttribute("isEdit", true);

        return "admin/trainers/form";
    }

    @PostMapping("/edit/{id}")
    public String updateTrainer(
            @PathVariable Integer id,
            @Valid @ModelAttribute("trainer") Trainer trainer,
            BindingResult bindingResult,
            @RequestParam(required = false) Integer staffId,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (trainerService.getTrainerById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy huấn luyện viên");
            return "redirect:/admin/trainers";
        }

        if (staffId == null) {
            bindingResult.reject("staffId", "Vui lòng chọn nhân viên");
        } else if (trainerService.existsByStaffId(staffId, id)) {
            bindingResult.reject("staffId", "Nhân viên này đã là huấn luyện viên");
        }

        if (bindingResult.hasErrors()) {
            trainer.setTrainerId(id);
            model.addAttribute("pageTitle", "Cập nhật huấn luyện viên");
            model.addAttribute("activePage", "trainers");
            model.addAttribute("staffs", trainerService.getAvailableStaffForTrainer());
            model.addAttribute("isEdit", true);
            return "admin/trainers/form";
        }

        trainerService.updateTrainer(id, trainer, staffId, photoFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật huấn luyện viên thành công");
        return "redirect:/admin/trainers";
    }

    @PostMapping("/delete/{id}")
    public String deleteTrainer(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        boolean deleted = trainerService.softDeleteTrainer(id);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "Ngừng huấn luyện viên thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy huấn luyện viên");
        }

        return "redirect:/admin/trainers";
    }
}