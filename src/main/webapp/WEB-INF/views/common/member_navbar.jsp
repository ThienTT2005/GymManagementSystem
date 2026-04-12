<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/member/dashboard">
            <i class="bi bi-lightning-charge-fill text-warning me-1"></i>GYM PRO
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMember">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarMember">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle fs-5"></i>
                        <span>
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedInUser}">
                                    <c:out value="${sessionScope.loggedInUser.fullName}" />
                                </c:when>
                                <c:otherwise>Member</c:otherwise>
                            </c:choose>
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/profile">
                            <i class="bi bi-person me-2"></i>Thông tin cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
