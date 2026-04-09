<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="admin-header">
    <div class="admin-header-left">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand-box">
            <img src="${pageContext.request.contextPath}/assets/images/logo-gym.png" alt="Logo" class="brand-logo">
            <span class="brand-text">Admin</span>
        </a>
    </div>

    <div class="admin-header-right">
        <div class="admin-search-wrapper">
            <button type="button" class="header-icon-btn" id="adminSearchToggleBtn" title="Tìm kiếm">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <form method="get"
                  action="${pageContext.request.contextPath}/admin/dashboard"
                  class="admin-search-dropdown"
                  id="adminSearchDropdown">
                <div class="admin-search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="keyword" placeholder="Tìm nhanh trong admin..." autocomplete="off">
                </div>
                <div class="admin-search-hint">
                    Ví dụ: người dùng, hội viên, dịch vụ, gói tập, thanh toán
                </div>
            </form>
        </div>

        <div class="admin-notification-wrapper">
            <button type="button" class="header-icon-btn" id="adminNotificationToggleBtn" title="Thông báo">
                <i class="fa-solid fa-bell"></i>
                <c:if test="${not empty headerNotifications}">
                    <span class="notification-dot"></span>
                </c:if>
            </button>

            <div class="admin-notification-dropdown" id="adminNotificationDropdown">
                <div class="notification-header">Thông báo quản trị</div>

                <c:choose>
                    <c:when test="${not empty headerNotifications}">
                        <c:forEach var="n" items="${headerNotifications}">
                            <a href="${pageContext.request.contextPath}${n.targetUrl}" class="notification-item">
                                <div class="noti-title">${n.title}</div>
                                <div class="noti-content">${n.content}</div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="notification-empty">Không có thông báo</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="admin-user-menu">
            <button type="button" class="admin-user-box" id="userMenuToggle">
                <img src="${pageContext.request.contextPath}/assets/images/${sessionScope.loggedInUser.avatarOrDefault}"
                     class="admin-avatar-img"
                     alt="Avatar">

                <span class="admin-user-name">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser.displayName}">
                            ${sessionScope.loggedInUser.displayName}
                        </c:when>
                        <c:otherwise>Admin</c:otherwise>
                    </c:choose>
                </span>

                <i class="fa-solid fa-chevron-down admin-user-arrow"></i>
            </button>

            <div class="admin-dropdown-menu" id="userDropdownMenu">
                <div class="dropdown-user-info">
                    <div class="dropdown-user-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.displayName}">
                                ${sessionScope.loggedInUser.displayName}
                            </c:when>
                            <c:otherwise>Admin</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="dropdown-user-role">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.roleName}">
                                ${sessionScope.loggedInUser.roleName}
                            </c:when>
                            <c:otherwise>ADMIN</c:otherwise>
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
        const userToggle = document.getElementById("userMenuToggle");
        const userDropdown = document.getElementById("userDropdownMenu");
        const notificationToggleBtn = document.getElementById("adminNotificationToggleBtn");
        const notificationDropdown = document.getElementById("adminNotificationDropdown");
        const searchToggleBtn = document.getElementById("adminSearchToggleBtn");
        const searchDropdown = document.getElementById("adminSearchDropdown");

        function closeAllDropdowns() {
            if (userDropdown) userDropdown.classList.remove("show");
            if (notificationDropdown) notificationDropdown.classList.remove("show");
            if (searchDropdown) searchDropdown.classList.remove("show");
        }

        if (userToggle && userDropdown) {
            userToggle.addEventListener("click", function (e) {
                e.stopPropagation();
                const shown = userDropdown.classList.contains("show");
                closeAllDropdowns();
                if (!shown) userDropdown.classList.add("show");
            });
        }

        if (notificationToggleBtn && notificationDropdown) {
            notificationToggleBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                const shown = notificationDropdown.classList.contains("show");
                closeAllDropdowns();
                if (!shown) notificationDropdown.classList.add("show");
            });
        }

        if (searchToggleBtn && searchDropdown) {
            searchToggleBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                const shown = searchDropdown.classList.contains("show");
                closeAllDropdowns();
                if (!shown) {
                    searchDropdown.classList.add("show");
                    const input = searchDropdown.querySelector("input[name='keyword']");
                    if (input) input.focus();
                }
            });
        }

        document.addEventListener("click", function () {
            closeAllDropdowns();
        });

        [userDropdown, notificationDropdown, searchDropdown].forEach(function (el) {
            if (el) {
                el.addEventListener("click", function (e) {
                    e.stopPropagation();
                });
            }
        });
    });
</script>
