package com.gym.GymManagementSystem.interceptor;

import com.gym.GymManagementSystem.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // 🔥 QUAN TRỌNG: cho phép truy cập các route public
        if (path.equals("/login") ||
                path.equals("/register") ||
                path.equals("/") ||
                path.startsWith("/assets/") ||
                path.startsWith("/uploads/") ||
                path.startsWith("/error") ||
                path.equals("/403")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        User loggedInUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        if (loggedInUser.getStatus() == null || loggedInUser.getStatus() != 1) {
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        return true;
    }
}