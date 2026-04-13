<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<aside class="app-sidebar">
    <div class="sidebar-brand">
        <h2>Huấn luyện viên</h2>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/trainer/dashboard"
           class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ</span>
        </a>

        <a href="${pageContext.request.contextPath}/trainer/classes"
           class="sidebar-link ${activePage == 'classes' ? 'active' : ''}">
            <i class="fa-solid fa-dumbbell"></i>
            <span>Lớp phụ trách</span>
        </a>

        <a href="${pageContext.request.contextPath}/trainer/schedule"
           class="sidebar-link ${activePage == 'schedule' ? 'active' : ''}">
            <i class="fa-solid fa-calendar-days"></i>
            <span>Lịch dạy</span>
        </a>

        <a href="${pageContext.request.contextPath}/trainer/class-members"
           class="sidebar-link ${activePage == 'class-members' ? 'active' : ''}">
            <i class="fa-solid fa-users"></i>
            <span>Học viên</span>
        </a>

        <a href="${pageContext.request.contextPath}/trainer/profile"
           class="sidebar-link ${activePage == 'profile' ? 'active' : ''}">
            <i class="fa-solid fa-id-card"></i>
            <span>Hồ sơ cá nhân</span>
        </a>
    </nav>
</aside>