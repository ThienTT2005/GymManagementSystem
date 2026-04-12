package com.gym.GymManagementSystem.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class AdminAuthFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());

        if (path.startsWith("/admin")) {
            HttpSession session = request.getSession(false);
            LoggedInUser loggedInUser = session != null ? (LoggedInUser) session.getAttribute("loggedInUser") : null;
            boolean allowed = loggedInUser != null
                    && loggedInUser.getRoleName() != null
                    && isAdminAreaRole(loggedInUser.getRoleName());

            if (!allowed) {
                response.sendRedirect(contextPath + "/pages/login.jsp");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private static boolean isAdminAreaRole(String roleName) {
        String r = roleName.trim();
        return r.equalsIgnoreCase("ADMIN")
                || r.equalsIgnoreCase("Admin")
                || r.equalsIgnoreCase("STAFF");
    }
}

