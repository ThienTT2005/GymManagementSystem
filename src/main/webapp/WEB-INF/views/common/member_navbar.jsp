<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gym.GymManagementSystem.model.User" %>
<%@ page import="com.gym.GymManagementSystem.model.Member" %>
<%@ page import="com.gym.GymManagementSystem.model.Notification" %>
<%@ page import="com.gym.GymManagementSystem.repository.MemberRepository" %>
<%@ page import="com.gym.GymManagementSystem.service.NotificationService" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User u = (User) session.getAttribute("loggedInUser");

    Member m = null;
    java.util.List<Notification> headerNotifications = java.util.Collections.emptyList();
    long unreadNotificationCount = 0;

    if (u != null) {
        MemberRepository memberRepo =
                WebApplicationContextUtils
                        .getRequiredWebApplicationContext(application)
                        .getBean(MemberRepository.class);

        NotificationService notificationService =
                WebApplicationContextUtils
                        .getRequiredWebApplicationContext(application)
                        .getBean(NotificationService.class);

        m = memberRepo.findByUserUserId(u.getUserId()).orElse(null);
        headerNotifications = notificationService.getLatestNotificationsByUserId(u.getUserId(), 6);
        unreadNotificationCount = notificationService.countUnreadByUserId(u.getUserId());
    }

    String avatarUrl = null;
    if (m != null && m.getAvatar() != null && !m.getAvatar().trim().isEmpty()) {
        if (m.getAvatar().startsWith("memberavt/")) {
            avatarUrl = request.getContextPath() + "/uploads/" + m.getAvatar();
        } else {
            avatarUrl = request.getContextPath() + "/" + m.getAvatar();
        }
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-danger sticky-top shadow">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/member/dashboard">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"
                 style="height: 40px; vertical-align: middle;">GYM PRO
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMember">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navMember">
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <li class="nav-item dropdown">
                    <a class="nav-link position-relative" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-bell fs-5"></i>
                        <% if (unreadNotificationCount > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark">
                            <%= unreadNotificationCount %>
                        </span>
                        <% } %>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow" style="min-width: 360px; max-height: 420px; overflow-y: auto;">
                        <li class="dropdown-header d-flex justify-content-between align-items-center">
                            <strong>Thông báo</strong>
                            <span><%= unreadNotificationCount %> chưa đọc</span>
                        </li>

                        <% if (headerNotifications != null && !headerNotifications.isEmpty()) { %>
                        <% for (Notification n : headerNotifications) { %>
                        <li>
                            <a class="dropdown-item py-2"
                               href="<%= request.getContextPath() %>/notifications/go?id=<%= n.getNotificationId() %>&target=<%= n.getTargetUrl() == null ? "" : n.getTargetUrl() %>">
                                <div class="d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong><%= n.getTitle() %></strong>
                                        <% if (n.isUnread()) { %>
                                        <span class="badge bg-danger">Mới</span>
                                        <% } %>
                                    </div>
                                    <% if (n.getMessage() != null && !n.getMessage().isBlank()) { %>
                                    <span class="small text-muted"><%= n.getMessage() %></span>
                                    <% } %>
                                    <span class="small text-secondary"><%= n.getCreatedAtDisplay() %></span>
                                </div>
                            </a>
                        </li>
                        <% } %>
                        <% } else { %>
                        <li><span class="dropdown-item-text text-muted">Chưa có thông báo</span></li>
                        <% } %>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
                        <% if (avatarUrl != null) { %>
                        <img src="<%= avatarUrl %>"
                             style="width:32px;height:32px;border-radius:50%;object-fit:cover;">
                        <% } else { %>
                        <i class="bi bi-person-circle fs-5"></i>
                        <% } %>
                        <span><%= m != null ? m.getFullname() : "Member" %></span>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/profile">
                            <i class="bi bi-person me-2"></i>Thông tin cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/member/change-password">
                            <i class="bi bi-lock me-1"></i>Đổi mật khẩu</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/member/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>