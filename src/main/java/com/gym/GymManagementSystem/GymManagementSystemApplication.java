package com.gym.GymManagementSystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.boot.web.servlet.ServletComponentScan;

@EnableJpaRepositories(basePackages = "com.gym.GymManagementSystem.repository")
@ServletComponentScan(basePackages = "com.gym.GymManagementSystem.newsblog")
@SpringBootApplication
public class GymManagementSystemApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(GymManagementSystemApplication.class, args);
	}

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(GymManagementSystemApplication.class);
	}
}
