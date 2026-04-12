package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.GymPackage;
import com.gym.GymManagementSystem.repository.GymPackageRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class PricingController {

    private final GymPackageRepository packageRepository;

    public PricingController(GymPackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    @GetMapping("/pricing")
    public String showPricing(Model model) {
        List<GymPackage> packages = packageRepository.findAll();
        model.addAttribute("packages", packages);
        return "pages/pricing";
    }
}
