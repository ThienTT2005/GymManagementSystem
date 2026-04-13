package com.gym.GymManagementSystem.interceptor;

import com.gym.GymManagementSystem.constants.RoleConstant;
import com.gym.GymManagementSystem.model.Role;
import com.gym.GymManagementSystem.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        User loggedInUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = resolveRoleName(session, loggedInUser);
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if (path.startsWith("/admin/") && !RoleConstant.ADMIN_NAME.equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/403");
            return false;
        }

        if (path.startsWith("/receptionist/") && !RoleConstant.RECEPTIONIST_NAME.equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/403");
            return false;
        }

        if (path.startsWith("/trainer/") && !RoleConstant.TRAINER_NAME.equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/403");
            return false;
        }

        if (path.startsWith("/member/") && !RoleConstant.MEMBER_NAME.equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/403");
            return false;
        }

        return true;
    }

    private String resolveRoleName(HttpSession session, User user) {
        if (session != null) {
            Object sessionRole = session.getAttribute("roleName");
            if (sessionRole instanceof String) {
                String roleName = (String) sessionRole;
                if (!roleName.isBlank()) {
                    return roleName;
                }
            }
        }

        if (user == null) {
            return null;
        }

        Role role = user.getRole();
        if (role == null) {
            return null;
        }

        try {
            return role.getRoleName();
        } catch (Exception e) {
            return null;
        }
    }
}