package com.gym.GymManagementSystem.controller.admin;

import com.gym.GymManagementSystem.entity.Contact;
import com.gym.GymManagementSystem.service.ContactService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/contacts")
public class AdminContactController {

    private final ContactService contactService;

    public AdminContactController(ContactService contactService) {
        this.contactService = contactService;
    }

    @GetMapping
    public String listContacts(@RequestParam(value = "keyword", required = false) String keyword,
                               @RequestParam(value = "status", required = false) String status,
                               @RequestParam(value = "page", defaultValue = "0") int page,
                               @RequestParam(value = "size", defaultValue = "5") int size,
                               Model model) {

        var contactPage = contactService.searchContacts(keyword, status, page, size);

        model.addAttribute("pageTitle", "Liên hệ");
        model.addAttribute("contactList", contactPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", contactPage.getTotalPages());
        model.addAttribute("size", size);

        return "admin/contacts/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        Contact contact = new Contact();
        contact.setContactDate(LocalDate.now());
        contact.setStatus("Chưa xử lý");

        model.addAttribute("pageTitle", "Thêm liên hệ");
        model.addAttribute("contact", contact);
        return "admin/contacts/form";
    }

    @PostMapping("/save")
    public String saveContact(@ModelAttribute("contact") Contact contact) {
        if (contact.getContactDate() == null) {
            contact.setContactDate(LocalDate.now());
        }
        if (contact.getStatus() == null || contact.getStatus().isBlank()) {
            contact.setStatus("Chưa xử lý");
        }
        contactService.save(contact);
        return "redirect:/admin/contacts";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Contact contact = contactService.findById(id);
        model.addAttribute("pageTitle", "Sửa liên hệ");
        model.addAttribute("contact", contact);
        return "admin/contacts/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteContact(@PathVariable Long id) {
        contactService.deleteById(id);
        return "redirect:/admin/contacts";
    }

    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable Long id) {
        contactService.toggleStatus(id);
        return "redirect:/admin/contacts";
    }
}