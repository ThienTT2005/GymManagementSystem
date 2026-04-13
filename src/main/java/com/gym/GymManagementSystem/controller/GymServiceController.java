package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.ServiceGym;
import com.gym.GymManagementSystem.repository.ServiceRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class GymServiceController {

    private final ServiceRepository serviceRepository;

    public GymServiceController(ServiceRepository serviceRepository) {
        this.serviceRepository = serviceRepository;
    }

    @GetMapping("/services")
    public String showServices(Model model) {
        List<ServiceGym> services = serviceRepository.findByStatus(1);
        model.addAttribute("services", services);
        return "pages/services";
    }

    @GetMapping("/services/{id}")
    public String showServiceDetail(@PathVariable("id") Integer id, Model model) {
        ServiceGym service = serviceRepository.findById(id).orElse(null);
        if (service == null || service.getStatus() == 0) {
            return "redirect:/services";
        }
        model.addAttribute("service", service);
        return "pages/service_detail";
    }
}