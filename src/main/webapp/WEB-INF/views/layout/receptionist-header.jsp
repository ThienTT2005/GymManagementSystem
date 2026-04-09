<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="receptionist-header">
    <div class="header-left">
        <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="brand-box">
            <img src="${pageContext.request.contextPath}/assets/images/logo-gym.png" alt="Logo" class="brand-logo">
            <span class="brand-text">Nhóm 4</span>
        </a>
    </div>

    <div class="header-right">
        <div class="header-search-wrapper">
            <button type="button" class="header-icon search-toggle-btn" id="searchToggleBtn" title="Tìm kiếm chức năng">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <form method="get"
                  action="${pageContext.request.contextPath}/receptionist/search"
                  class="header-search-dropdown"
                  id="headerSearchDropdown">
                <div class="header-search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="keyword" placeholder="Tìm chức năng..." autocomplete="off">
                </div>
                <div class="header-search-hint">
                    Ví dụ: hội viên, gói tập, đăng ký lớp, thanh toán, tập thử
                </div>
            </form>
        </div>

        <div class="header-notification-wrapper">
            <button type="button" class="header-icon notification-btn" id="notificationToggleBtn" title="Thông báo">
                <i class="fa-solid fa-bell"></i>
                <c:if test="${not empty headerNotifications}">
                    <span class="notification-dot"></span>
                </c:if>
            </button>

            <div class="notification-dropdown" id="notificationDropdown">
                <div class="notification-header">Thông báo</div>

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

        <div class="user-menu">
            <button type="button" class="user-box" id="userToggle">
                <img src="${pageContext.request.contextPath}/assets/images/${sessionScope.loggedInUser.avatarOrDefault}"
                     class="avatar" alt="Avatar">

                <span class="user-name">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser.displayName}">
                            ${sessionScope.loggedInUser.displayName}
                        </c:when>
                        <c:otherwise>Receptionist</c:otherwise>
                    </c:choose>
                </span>

                <i class="fa-solid fa-chevron-down"></i>
            </button>

            <div class="user-dropdown" id="userDropdown">
                <a href="${pageContext.request.contextPath}/receptionist/profile">Thông tin cá nhân</a>
                <a href="${pageContext.request.contextPath}/receptionist/change-password">Đổi mật khẩu</a>
                <a href="${pageContext.request.contextPath}/logout" class="logout">Đăng xuất</a>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const userToggle = document.getElementById("userToggle");
        const userDropdown = document.getElementById("userDropdown");
        const notificationToggleBtn = document.getElementById("notificationToggleBtn");
        const notificationDropdown = document.getElementById("notificationDropdown");
        const searchToggleBtn = document.getElementById("searchToggleBtn");
        const headerSearchDropdown = document.getElementById("headerSearchDropdown");

        function closeAllDropdowns() {
            if (userDropdown) userDropdown.classList.remove("show");
            if (notificationDropdown) notificationDropdown.classList.remove("show");
            if (headerSearchDropdown) headerSearchDropdown.classList.remove("show");
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

        if (searchToggleBtn && headerSearchDropdown) {
            searchToggleBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                const shown = headerSearchDropdown.classList.contains("show");
                closeAllDropdowns();
                if (!shown) {
                    headerSearchDropdown.classList.add("show");
                    const input = headerSearchDropdown.querySelector("input[name='keyword']");
                    if (input) input.focus();
                }
            });
        }

        document.addEventListener("click", function () {
            closeAllDropdowns();
        });

        [userDropdown, notificationDropdown, headerSearchDropdown].forEach(function (el) {
            if (el) {
                el.addEventListener("click", function (e) {
                    e.stopPropagation();
                });
            }
        });
    });
</script>
