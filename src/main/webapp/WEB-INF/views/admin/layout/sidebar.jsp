<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<div class="admin-sidebar">
    <div class="sidebar-inner">
        <ul class="sidebar-menu">

            <li>
                <a class="${currentUri.contains('/admin/dashboard') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <span class="menu-icon"><i class="fa-solid fa-house"></i></span>
                    <span class="menu-text">Trang chủ</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/users') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/users">
                    <span class="menu-icon"><i class="fa-solid fa-user"></i></span>
                    <span class="menu-text">Quản lý người dùng</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/members') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/members">
                    <span class="menu-icon"><i class="fa-solid fa-users"></i></span>
                    <span class="menu-text">Quản lý hội viên</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/branches') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/branches">
                    <span class="menu-icon"><i class="fa-solid fa-building"></i></span>
                    <span class="menu-text">Chi nhánh</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/services') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/services">
                    <span class="menu-icon"><i class="fa-solid fa-layer-group"></i></span>
                    <span class="menu-text">Dịch vụ</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/packages') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/packages">
                    <span class="menu-icon"><i class="fa-solid fa-box-open"></i></span>
                    <span class="menu-text">Gói tập</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/payments') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/payments">
                    <span class="menu-icon"><i class="fa-solid fa-credit-card"></i></span>
                    <span class="menu-text">Thanh toán</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/trials') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/trials">
                    <span class="menu-icon"><i class="fa-solid fa-clipboard"></i></span>
                    <span class="menu-text">Đăng ký tập thử</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/contacts') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/contacts">
                    <span class="menu-icon"><i class="fa-solid fa-comment-dots"></i></span>
                    <span class="menu-text">Liên hệ</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/news') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/news">
                    <span class="menu-icon"><i class="fa-solid fa-newspaper"></i></span>
                    <span class="menu-text">Tin tức</span>
                </a>
            </li>

            <li>
                <a class="${currentUri.contains('/admin/reports') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/reports">
                    <span class="menu-icon"><i class="fa-solid fa-chart-column"></i></span>
                    <span class="menu-text">Báo cáo</span>
                </a>
            </li>

        </ul>
    </div>
</div>