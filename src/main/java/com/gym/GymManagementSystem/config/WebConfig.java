package com.gym.GymManagementSystem.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        // avatar
        registry.addResourceHandler("/memberavt/**")
                .addResourceLocations("file:uploads/memberavt/");

        // payment proof
        registry.addResourceHandler("/uploads/payments/**")
                .addResourceLocations("file:uploads/payments/");
    }
}
