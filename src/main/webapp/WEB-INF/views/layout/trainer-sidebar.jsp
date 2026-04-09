<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="app-sidebar">
    <div class="sidebar-brand">
        <h2>Trainer Panel</h2>
        <p>Gym Management</p>
    </div>

    <nav class="sidebar-nav">
        <a class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/trainer/dashboard">
            <i class="fa-solid fa-chart-line"></i>
            <span>Dashboard</span>
        </a>

        <a class="sidebar-link ${activePage == 'schedule' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/trainer/schedule">
            <i class="fa-solid fa-calendar-days"></i>
            <span>Lịch dạy</span>
        </a>

        <a class="sidebar-link ${activePage == 'class-members' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/trainer/class-members">
            <i class="fa-solid fa-users"></i>
            <span>Học viên lớp</span>
        </a>

        <a class="sidebar-link ${activePage == 'profile' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/trainer/profile">
            <i class="fa-solid fa-user"></i>
            <span>Hồ sơ cá nhân</span>
        </a>
    </nav>
</aside>