<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="admin-header">
    <div class="admin-header-left">
        <div class="brand-box">
            <img
                src="${pageContext.request.contextPath}/assets/images/logo.png"
                alt="Logo"
                class="brand-logo">
            <span class="brand-text">Nhóm 4</span>
        </div>
    </div>

    <div class="admin-header-right">
        <button type="button" class="header-icon-btn" title="Tìm kiếm">
            <i class="fa-solid fa-magnifying-glass"></i>
        </button>

        <button type="button" class="header-icon-btn notification-btn" title="Thông báo">
            <i class="fa-solid fa-bell"></i>
            <span class="notification-dot"></span>
        </button>

        <div class="admin-user-menu">
            <button type="button" class="admin-user-box" id="userMenuToggle">
                <img
                    src="${pageContext.request.contextPath}/assets/images/avatar.png"
                    alt="Avatar"
                    class="admin-avatar-img">

                <span class="admin-user-name">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser.fullName}">
                            ${sessionScope.loggedInUser.fullName}
                        </c:when>
                        <c:otherwise>
                            Admin
                        </c:otherwise>
                    </c:choose>
                </span>

                <i class="fa-solid fa-chevron-down admin-user-arrow"></i>
            </button>

            <div class="admin-dropdown-menu" id="userDropdownMenu">
                <div class="dropdown-user-info">
                    <div class="dropdown-user-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.fullName}">
                                ${sessionScope.loggedInUser.fullName}
                            </c:when>
                            <c:otherwise>
                                Admin
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="dropdown-user-role">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.roleName}">
                                ${sessionScope.loggedInUser.roleName}
                            </c:when>
                            <c:otherwise>
                                Quản trị viên
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-item">
                    <i class="fa-regular fa-user"></i> Thông tin tài khoản
                </a>

                <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-item">
                    <i class="fa-solid fa-key"></i> Đổi mật khẩu
                </a>

                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item logout-item">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const toggle = document.getElementById("userMenuToggle");
        const menu = document.getElementById("userDropdownMenu");

        if (toggle && menu) {
            toggle.addEventListener("click", function (e) {
                e.stopPropagation();
                menu.classList.toggle("show");
            });

            document.addEventListener("click", function () {
                menu.classList.remove("show");
            });

            menu.addEventListener("click", function (e) {
                e.stopPropagation();
            });
        }
    });
</script>