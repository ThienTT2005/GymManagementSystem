<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.gym.GymManagementSystem.model.User u =
            (com.gym.GymManagementSystem.model.User) session.getAttribute("loggedUser");

    com.gym.GymManagementSystem.model.Member m = null;
    if (u != null) {
        com.gym.GymManagementSystem.repository.MemberRepository repo =
                org.springframework.web.context.support.WebApplicationContextUtils
                        .getRequiredWebApplicationContext(application)
                        .getBean(com.gym.GymManagementSystem.repository.MemberRepository.class);

        m = repo.findByUserUserId(u.getUserId()).orElse(null);
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-danger sticky-top shadow">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/member/dashboard">
            <i class="bi bi-lightning-charge-fill text-warning me-1"></i>GYM PRO
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMember">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMember">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
                        <% if (m != null && m.getAvatar() != null) { %>
                        <img src="<%= request.getContextPath() + "/" + m.getAvatar() %>"
                             style="width:32px;height:32px;border-radius:50%;object-fit:cover;">
                        <% } else { %>
                        <i class="bi bi-person-circle fs-5"></i>
                        <% } %>
                        <span><%= m != null ? m.getFullname() : "Member" %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/profile">
                            <i class="bi bi-person me-2"></i>Thông tin cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/member/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
