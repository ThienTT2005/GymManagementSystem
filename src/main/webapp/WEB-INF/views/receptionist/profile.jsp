<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ttt.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Hồ sơ cá nhân</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="profile-page-grid">
                <div class="profile-left-card">
                    <img class="profile-avatar-large"
                         src="${pageContext.request.contextPath}/uploads/${staff != null && not empty staff.avatar ? staff.avatar : 'default-avatar.png'}"
                         alt="${user.username}">

                    <h3>${staff != null && not empty staff.fullName ? staff.fullName : user.username}</h3>

                    <div class="profile-role-text">
                        ${user.roleName}
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge active">${user.roleName}</span>
                        <span class="status-badge ${user.status == 1 ? 'active' : 'inactive'}">
                            ${user.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>

                    <div class="profile-quick-info">
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-user"></i>
                            <span>${user.username}</span>
                        </div>
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-envelope"></i>
                            <span>${staff != null && not empty staff.email ? staff.email : 'Chưa cập nhật'}</span>
                        </div>
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-phone"></i>
                            <span>${staff != null && not empty staff.phone ? staff.phone : 'Chưa cập nhật'}</span>
                        </div>
                    </div>
                </div>

                <div class="profile-right-card">
                    <div class="profile-section-title">
                        <h3>Thông tin chi tiết</h3>
                    </div>

                    <div class="profile-detail-grid">
                        <div class="profile-detail-item">
                            <label>Username</label>
                            <p>${user.username}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Vai trò</label>
                            <p>${user.roleName}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Họ tên</label>
                            <p>${staff != null && not empty staff.fullName ? staff.fullName : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${staff != null && not empty staff.email ? staff.email : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Số điện thoại</label>
                            <p>${staff != null && not empty staff.phone ? staff.phone : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Địa chỉ</label>
                            <p>${staff != null && not empty staff.address ? staff.address : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Chức vụ</label>
                            <p>${staff != null && not empty staff.position ? staff.position : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${staff != null && not empty staff.dob ? staff.dob : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Mức lương</label>
                            <p>
                                <c:choose>
                                    <c:when test="${staff != null && staff.salary != null}">
                                        <fmt:formatNumber value="${staff.salary}" type="number" groupingUsed="true"/> VNĐ
                                    </c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/profile/edit" class="btn-primary">
                            <i class="fa-solid fa-pen"></i>
                            <span>Cập nhật hồ sơ</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/receptionist/profile/change-password" class="btn-light">
                            <i class="fa-solid fa-key"></i>
                            <span>Đổi mật khẩu</span>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>