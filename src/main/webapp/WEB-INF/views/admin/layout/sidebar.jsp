<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="app-sidebar">
    <div class="sidebar-brand">
        <h2>Admin Panel</h2>
        <p>Gym Management</p>
    </div>

    <nav class="sidebar-nav">
        <a class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-chart-line"></i>
            <span>Dashboard</span>
        </a>

        <a class="sidebar-link ${activePage == 'users' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/users">
            <i class="fa-solid fa-user-shield"></i>
            <span>Tài khoản</span>
        </a>

        <a class="sidebar-link ${activePage == 'members' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/members">
            <i class="fa-solid fa-users"></i>
            <span>Hội viên</span>
        </a>

        <a class="sidebar-link ${activePage == 'staff' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/staff">
            <i class="fa-solid fa-id-card"></i>
            <span>Nhân viên</span>
        </a>

        <a class="sidebar-link ${activePage == 'trainers' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/trainers">
            <i class="fa-solid fa-person-running"></i>
            <span>Huấn luyện viên</span>
        </a>

        <a class="sidebar-link ${activePage == 'packages' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/packages">
            <i class="fa-solid fa-box-open"></i>
            <span>Gói tập</span>
        </a>

        <a class="sidebar-link ${activePage == 'services' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/services">
            <i class="fa-solid fa-heart-pulse"></i>
            <span>Dịch vụ</span>
        </a>

        <a class="sidebar-link ${activePage == 'classes' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/classes">
            <i class="fa-solid fa-dumbbell"></i>
            <span>Lớp học</span>
        </a>

        <a class="sidebar-link ${activePage == 'schedules' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/schedules">
            <i class="fa-solid fa-calendar-days"></i>
            <span>Lịch học</span>
        </a>

        <a class="sidebar-link ${activePage == 'memberships' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/memberships">
            <i class="fa-solid fa-address-card"></i>
            <span>Gói hội viên</span>
        </a>

        <a class="sidebar-link ${activePage == 'class-registrations' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/class-registrations">
            <i class="fa-solid fa-list-check"></i>
            <span>Đăng ký lớp</span>
        </a>

        <a class="sidebar-link ${activePage == 'payments' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/payments">
            <i class="fa-solid fa-money-check-dollar"></i>
            <span>Thanh toán</span>
        </a>

        <a class="sidebar-link ${activePage == 'trials' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/trials">
            <i class="fa-solid fa-stopwatch"></i>
            <span>Tập thử</span>
        </a>

        <a class="sidebar-link ${activePage == 'contacts' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/contacts">
            <i class="fa-solid fa-comments"></i>
            <span>Tư vấn</span>
        </a>

        <a class="sidebar-link ${activePage == 'news' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/news">
            <i class="fa-solid fa-newspaper"></i>
            <span>Tin tức</span>
        </a>
    </nav>
</aside>