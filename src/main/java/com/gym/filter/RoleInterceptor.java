package com.gym.filter;

import com.gym.model.User;
import jakarta.servlet.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        String uri = request.getRequestURI();
        String role = user.getRole().getRoleName();

        if (uri.startsWith("/admin") && !role.equals("Admin")) {
            response.sendRedirect("/login");
            return false;
        }

        if (uri.startsWith("/trainer") && !role.equals("Trainer")) {
            response.sendRedirect("/login");
            return false;
        }

        if (uri.startsWith("/member") && !role.equals("Member")) {
            response.sendRedirect("/login");
            return false;
        }

        if (uri.startsWith("/receptionist") && !role.equals("Receptionist")) {
            response.sendRedirect("/login");
            return false;
        }

        return true;
    }
}