package com.gym.GymManagementSystem.config;

import com.gym.GymManagementSystem.interceptor.AuthInterceptor;
import com.gym.GymManagementSystem.interceptor.RoleInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AuthInterceptor authInterceptor;

    @Autowired
    private RoleInterceptor roleInterceptor;

    @Value("${app.upload.dir}")
    private String uploadDir;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/admin/**", "/trainer/**", "/member/**", "/receptionist/**")
                .excludePathPatterns(
                        "/login",
                        "/logout",
                        "/register",
                        "/assets/**",
                        "/uploads/**",
                        "/error",
                        "/403",
                        "/favicon.ico"
                );

        registry.addInterceptor(roleInterceptor)
                .addPathPatterns("/admin/**", "/trainer/**", "/member/**", "/receptionist/**")
                .excludePathPatterns(
                        "/login",
                        "/logout",
                        "/register",
                        "/assets/**",
                        "/uploads/**",
                        "/error",
                        "/403",
                        "/favicon.ico"
                );
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("/assets/");

        Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath.toString() + "/");
    }
}