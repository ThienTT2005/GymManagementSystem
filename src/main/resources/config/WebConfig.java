package config;

import com.gym.filter.AuthInterceptor;
import com.gym.filter.RoleInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AuthInterceptor authInterceptor;

    @Autowired
    private RoleInterceptor roleInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/admin/**", "/trainer/**", "/member/**", "/receptionist/**");

        registry.addInterceptor(roleInterceptor)
                .addPathPatterns("/admin/**", "/trainer/**", "/member/**", "/receptionist/**");
    }
}