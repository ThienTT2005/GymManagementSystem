<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String currentURI = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<nav class="col-md-3 col-lg-2 d-md-block bg-danger sidebar py-3" style="min-height:100vh;">
    <div class="position-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/dashboard") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/dashboard">
                    <i class="bi bi-speedometer2 me-2"></i>Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/profile") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/profile">
                    <i class="bi bi-person me-2"></i>Thông tin cá nhân
                </a>
            </li>
            <li class="nav-item mt-3 px-3">
                <small class="text-white fw-bold text-uppercase d-block mb-1" style="font-size:.75rem; letter-spacing:1px;">
                    LỊCH TẬP
                </small>
                <div style="height:1px; background:rgba(255,255,255,.3);"></div>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/schedules") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/schedules">
                    <i class="bi bi-calendar3 me-2"></i>Lịch tập
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/classes") ? "fw-bold" : "" %>"
                   href="<%= ctx %>/member/classes">&#128196; Đăng ký lớp học</a>
            </li>

            <li class="nav-item mt-3 px-3">
                <small class="text-white fw-bold text-uppercase d-block mb-1" style="font-size:.75rem; letter-spacing:1px;">
                    HỘI VIÊN
                </small>
                <div style="height:1px; background:rgba(255,255,255,.3);"></div>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/packages") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/packages">
                    <i class="bi bi-bag me-2"></i>Đăng ký hội viên
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/my-membership") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/my-membership">
                    <i class="bi bi-award me-2"></i>Gói hội viên của tôi
                </a>
            </li>
            <li class="nav-item mt-3 px-3">
                <small class="text-white fw-bold text-uppercase d-block mb-1" style="font-size:.75rem; letter-spacing:1px;">
                    KHÁC
                </small>
                <div style="height:1px; background:rgba(255,255,255,.3);"></div>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/history") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/history">
                    <i class="bi bi-clock-history me-2"></i>Lịch sử
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="<%= ctx %>/member/change-password">
                    <i class="bi bi-lock me-1"></i>Đổi mật khẩu</a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="<%= ctx %>/member/logout">&#128682; Đăng xuất</a>
            </li>
        </ul>
    </div>
</nav>
