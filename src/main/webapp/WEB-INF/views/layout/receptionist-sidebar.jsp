<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="receptionist-sidebar">
    <ul class="sidebar-menu">

        <li>
            <a class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/dashboard">
                <i class="fa-solid fa-house"></i>
                Dashboard
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'members' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/members">
                <i class="fa-solid fa-users"></i>
                Hội viên
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'memberships' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/memberships">
                <i class="fa-solid fa-box-open"></i>
                Đăng ký gói tập
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'class-registrations' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/class-registrations">
                <i class="fa-solid fa-layer-group"></i>
                Đăng ký lớp
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'payments' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/payments">
                <i class="fa-solid fa-wallet"></i>
                Thanh toán
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'trials' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/trials">
                <i class="fa-solid fa-file-pen"></i>
                Tập thử
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'consultations' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/consultations">
                <i class="fa-solid fa-comments"></i>
                Tư vấn
            </a>
        </li>

        <li>
            <a class="sidebar-link ${activePage == 'profile' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/receptionist/profile">
                <i class="fa-solid fa-user"></i>
                Hồ sơ cá nhân
            </a>
        </li>

    </ul>
</div>