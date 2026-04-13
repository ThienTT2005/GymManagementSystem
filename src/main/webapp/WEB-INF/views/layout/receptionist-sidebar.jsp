<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="app-sidebar receptionist-sidebar">
    <div class="sidebar-brand">
        <h2>Lễ tân</h2>
    </div>

    <nav class="sidebar-nav">
        <a class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/dashboard">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ</span>
        </a>

        <a class="sidebar-link ${activePage == 'members' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/members">
            <i class="fa-solid fa-users"></i>
            <span>Hội viên</span>
        </a>

        <a class="sidebar-link ${activePage == 'memberships' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/memberships">
            <i class="fa-solid fa-box-open"></i>
            <span>Đăng ký gói tập</span>
        </a>

        <a class="sidebar-link ${activePage == 'class-registrations' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/class-registrations">
            <i class="fa-solid fa-layer-group"></i>
            <span>Đăng ký lớp học</span>
        </a>

        <a class="sidebar-link ${activePage == 'payments' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/payments">
            <i class="fa-solid fa-credit-card"></i>
            <span>Thanh toán</span>
        </a>

        <a class="sidebar-link ${activePage == 'trials' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/trials">
            <i class="fa-solid fa-stopwatch"></i>
            <span>Tập thử</span>
        </a>

        <a class="sidebar-link ${activePage == 'consultations' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/receptionist/consultations">
            <i class="fa-solid fa-comments"></i>
            <span>Tư vấn</span>
        </a>
    </nav>
</aside>