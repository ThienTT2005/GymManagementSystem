package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.model.GymPackage;
import com.gym.GymManagementSystem.repository.PackageRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class PricingController {

    private final PackageRepository packageRepository;

    public PricingController(PackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    @GetMapping("/pricing")
    public String showPricing(Model model) {
        List<GymPackage> packages = packageRepository.findAll();
        model.addAttribute("packages", packages);
        return "pages/pricing";
    }
}
