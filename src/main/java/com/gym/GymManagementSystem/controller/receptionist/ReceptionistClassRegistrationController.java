package com.gym.GymManagementSystem.controller.receptionist;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/receptionist/class-registrations")
public class ReceptionistClassRegistrationController {

    private final ClassRegistrationService classRegistrationService;

    public ReceptionistClassRegistrationController(ClassRegistrationService classRegistrationService) {
        this.classRegistrationService = classRegistrationService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "") String keyword,
                       @RequestParam(required = false) String status,
                       @RequestParam(required = false) Integer classId,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "8") int size,
                       Model model) {

        Page<ClassRegistration> registrationPage =
                classRegistrationService.searchRegistrations(keyword, status, classId, page, size);

        model.addAttribute("pageTitle", "Đăng ký lớp học");
        model.addAttribute("activePage", "class-registrations");
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("classId", classId);
        model.addAttribute("registrationPage", registrationPage);
        model.addAttribute("classes", classRegistrationService.getAllClasses());

        return "receptionist/class-registrations/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        ClassRegistration registration = new ClassRegistration();
        registration.setStatus("PENDING");

        model.addAttribute("pageTitle", "Thêm đăng ký lớp");
        model.addAttribute("activePage", "class-registrations");
        model.addAttribute("registration", registration);
        model.addAttribute("members", classRegistrationService.getAllMembers());
        model.addAttribute("classes", classRegistrationService.getAllClasses());
        model.addAttribute("services", classRegistrationService.getAllServices());
        model.addAttribute("isEdit", false);

        return "receptionist/class-registrations/form";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("registration") ClassRegistration registration,
                         BindingResult bindingResult,
                         @RequestParam(required = false) Integer memberId,
                         @RequestParam(required = false) Integer classId,
                         @RequestParam(required = false) Integer serviceId,
                         Model model,
                         RedirectAttributes redirectAttributes) {

        if (memberId == null) {
            bindingResult.reject("memberId", "Vui lòng chọn hội viên");
        }
        if (classId == null) {
            bindingResult.reject("classId", "Vui lòng chọn lớp học");
        }

        if (classId != null) {
            GymClass selectedClass = classRegistrationService.getClassById(classId);
            if (!classRegistrationService.isClassAvailableForRegistration(selectedClass)) {
                bindingResult.reject("classId", "Lớp học này đã đầy hoặc đang ngừng hoạt động");
            }
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Thêm đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", false);
            return "receptionist/class-registrations/form";
        }

        try {
            classRegistrationService.createRegistration(registration, memberId, classId, serviceId);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký lớp thành công");
            return "redirect:/receptionist/class-registrations";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Thêm đăng ký lớp");
            model.addAttribute("activePage", "class-registrations");
            model.addAttribute("members", classRegistrationService.getAllMembers());
            model.addAttribute("classes", classRegistrationService.getAllClasses());
            model.addAttribute("services", classRegistrationService.getAllServices());
            model.addAttribute("isEdit", false);
            model.addAttribute("errorMessage", e.getMessage());
            return "receptionist/class-registrations/form";
        }
    }

    @PostMapping("/approve/{id}")
    public String approve(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            classRegistrationService.approve(id);
            redirectAttributes.addFlashAttribute("successMessage", "Duyệt đăng ký lớp thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể duyệt đăng ký lớp");
        }
        return "redirect:/receptionist/class-registrations";
    }

    @PostMapping("/reject/{id}")
    public String reject(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            classRegistrationService.reject(id);
            redirectAttributes.addFlashAttribute("successMessage", "Từ chối đăng ký lớp thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể từ chối đăng ký lớp");
        }
        return "redirect:/receptionist/class-registrations";
    }
}