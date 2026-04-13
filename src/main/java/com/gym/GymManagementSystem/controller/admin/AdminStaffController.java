package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.model.Staff;
import com.gym.GymManagementSystem.service.StaffService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;

@Controller
@RequestMapping("/admin/staff")
public class AdminStaffController {

    private final StaffService staffService;

    public AdminStaffController(StaffService staffService) {
        this.staffService = staffService;
    }

    @GetMapping
    public String listStaffs(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "8") int size,
            Model model
    ) {
        Page<Staff> staffPage = staffService.searchStaffs(keyword, position, status, page, size);

        model.addAttribute("pageTitle", "Quản lý nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("keyword", keyword);
        model.addAttribute("position", position);
        model.addAttribute("status", status);
        model.addAttribute("staffPage", staffPage);

        return "admin/staff/list";
    }

    @GetMapping("/detail/{id}")
    public String showDetail(@PathVariable Integer id,
                             Model model,
                             RedirectAttributes redirectAttributes) {

        Staff staff = staffService.getStaffById(id);

        if (staff == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        model.addAttribute("pageTitle", "Chi tiết nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("staff", staff);

        return "admin/staff/detail";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Staff staff = new Staff();
        staff.setStatus(1);

        model.addAttribute("pageTitle", "Thêm nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("staff", staff);
        model.addAttribute("users", staffService.getAssignableUsers());
        model.addAttribute("isEdit", false);

        return "admin/staff/form";
    }

    @PostMapping("/create")
    public String createStaff(
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String dob,
            @RequestParam(required = false) String note,
            @RequestParam(required = false) BigDecimal salary,
            @RequestParam(required = false) Integer status,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Staff staff = buildStaffFromRequest(
                fullName, phone, email, address, gender, dob, note, salary, status
        );

        try {
            if (userId != null && staffService.existsByUserId(userId, null)) {
                throw new IllegalArgumentException("Tài khoản này đã được gán cho nhân viên khác");
            }

            staffService.createStaff(staff, userId, avatarFile);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm nhân viên thành công");
            return "redirect:/admin/staff";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Thêm nhân viên");
            model.addAttribute("activePage", "staff");
            model.addAttribute("users", staffService.getAssignableUsers());
            model.addAttribute("isEdit", false);
            model.addAttribute("staff", staff);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/staff/form";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        Staff staff = staffService.getStaffById(id);
        if (staff == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        model.addAttribute("pageTitle", "Cập nhật nhân viên");
        model.addAttribute("activePage", "staff");
        model.addAttribute("staff", staff);
        model.addAttribute("users", staffService.getAssignableUsers(id));
        model.addAttribute("isEdit", true);

        return "admin/staff/form";
    }

    @PostMapping("/edit/{id}")
    public String updateStaff(
            @PathVariable Integer id,
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String dob,
            @RequestParam(required = false) String note,
            @RequestParam(required = false) BigDecimal salary,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String currentAvatar,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (staffService.getStaffById(id) == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        Staff staff = buildStaffFromRequest(
                fullName, phone, email, address, gender, dob, note, salary, status
        );
        staff.setStaffId(id);
        staff.setAvatar(currentAvatar);

        try {
            if (userId != null && staffService.existsByUserId(userId, id)) {
                throw new IllegalArgumentException("Tài khoản này đã được gán cho nhân viên khác");
            }

            staffService.updateStaff(id, staff, userId, avatarFile);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật nhân viên thành công");
            return "redirect:/admin/staff";
        } catch (IllegalArgumentException e) {
            model.addAttribute("pageTitle", "Cập nhật nhân viên");
            model.addAttribute("activePage", "staff");
            model.addAttribute("users", staffService.getAssignableUsers(id));
            model.addAttribute("isEdit", true);
            model.addAttribute("staff", staff);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/staff/form";
        }
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Integer id, RedirectAttributes redirectAttributes) {

        Staff staff = staffService.getStaffById(id);

        if (staff == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy nhân viên");
            return "redirect:/admin/staff";
        }

        staff.setStatus(staff.getStatus() == 1 ? 0 : 1);
        staffService.updateStaff(
                id,
                staff,
                staff.getUser() != null ? staff.getUser().getUserId() : null,
                null
        );

        redirectAttributes.addFlashAttribute(
                "successMessage",
                staff.getStatus() == 1 ? "Kích hoạt nhân viên thành công" : "Ngừng nhân viên thành công"
        );

        return "redirect:/admin/staff";
    }

    private Staff buildStaffFromRequest(String fullName,
                                        String phone,
                                        String email,
                                        String address,
                                        String gender,
                                        String dob,
                                        String note,
                                        BigDecimal salary,
                                        Integer status) {
        Staff staff = new Staff();
        staff.setFullName(fullName);
        staff.setPhone(phone);
        staff.setEmail(email);
        staff.setAddress(address);
        staff.setGender(gender);
        staff.setNote(note);
        staff.setSalary(salary);
        staff.setStatus(status != null ? status : 1);

        if (dob != null && !dob.isBlank()) {
            try {
                staff.setDob(LocalDate.parse(dob));
            } catch (Exception ignored) {
            }
        }

        return staff;
    }
}