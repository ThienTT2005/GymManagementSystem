<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">
            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <div class="page-header">
                <div>
                    <h1>Hồ sơ quản trị viên</h1>
                </div>
            </div>

            <div class="profile-page-grid">
                <div class="profile-left-card">
                    <img class="profile-avatar-large"
                         src="${empty staff or empty staff.avatar ? pageContext.request.contextPath.concat('/assets/images/default-avatar.png') : pageContext.request.contextPath.concat('/uploads/').concat(staff.avatar)}"
                         alt="${empty staff or empty staff.fullName ? loggedInUser.displayName : staff.fullName}">

                    <h3>
                        <c:choose>
                            <c:when test="${not empty staff and not empty staff.fullName}">
                                ${staff.fullName}
                            </c:when>
                            <c:otherwise>
                                ${loggedInUser.displayName}
                            </c:otherwise>
                        </c:choose>
                    </h3>

                    <div class="profile-role-text">
                        ${loggedInUser.roleName}
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge active">${loggedInUser.roleName}</span>
                        <span class="status-badge ${loggedInUser.status == 1 ? 'active' : 'inactive'}">
                            ${loggedInUser.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>

                    <div class="profile-quick-info">
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-user"></i>
                            <span>${loggedInUser.username}</span>
                        </div>
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-envelope"></i>
                            <span>${empty staff or empty staff.email ? 'Chưa cập nhật' : staff.email}</span>
                        </div>
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-phone"></i>
                            <span>${empty staff or empty staff.phone ? 'Chưa cập nhật' : staff.phone}</span>
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
                            <p>${loggedInUser.username}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Họ tên</label>
                            <p>${empty staff or empty staff.fullName ? loggedInUser.displayName : staff.fullName}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${empty staff or empty staff.email ? 'Chưa cập nhật' : staff.email}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Số điện thoại</label>
                            <p>${empty staff or empty staff.phone ? 'Chưa cập nhật' : staff.phone}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Địa chỉ</label>
                            <p>${empty staff or empty staff.address ? 'Chưa cập nhật' : staff.address}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Giới tính</label>
                            <p>${empty staff or empty staff.gender ? 'Chưa cập nhật' : staff.gender}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${empty staff or empty staff.dob ? 'Chưa cập nhật' : staff.dob}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Chức vụ</label>
                            <p>${empty staff or empty staff.position ? 'Chưa cập nhật' : staff.position}</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/profile/edit" class="btn-primary">
                            <i class="fa-solid fa-pen"></i>
                            <span>Chỉnh sửa hồ sơ</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/profile/change-password" class="btn-light">
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