<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String currentURI = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar py-3" style="min-height:100vh;">
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
            <li class="nav-item mt-2">
                <small class="text-secondary px-3 text-uppercase" style="font-size:.7rem;">Phòng gym</small>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/clubs") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/clubs">
                    <i class="bi bi-building me-2"></i>Chi nhánh
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/schedules") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/schedules">
                    <i class="bi bi-calendar3 me-2"></i>Lịch tập
                </a>
            </li>
            <li class="nav-item mt-2">
                <small class="text-secondary px-3 text-uppercase" style="font-size:.7rem;">Gói tập</small>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/packages") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/packages">
                    <i class="bi bi-bag me-2"></i>Đăng ký gói tập
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/my-package") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/my-package">
                    <i class="bi bi-award me-2"></i>Gói tập của tôi
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white <%= currentURI.contains("/history") ? "active fw-bold" : "" %>"
                   href="<%= ctx %>/member/history">
                    <i class="bi bi-clock-history me-2"></i>Lịch sử
                </a>
            </li>
        </ul>
    </div>
</nav>
