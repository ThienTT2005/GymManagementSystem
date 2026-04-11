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
            <div class="page-header">
                <div>
                    <h1>Chi tiết nhân viên</h1>
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
                         src="${pageContext.request.contextPath}/${empty staff.avatar ? 'assets/images/default-avatar.png' : (staff.avatar.startsWith('assets/') ? staff.avatar : 'uploads/'.concat(staff.avatar))}"
                         alt="${staff.fullName}">

                    <div>
                        <h3>${staff.fullName}</h3>
                        <div class="profile-role-text">${empty staff.position ? 'Nhân viên' : staff.position}</div>
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge ${staff.status == 1 ? 'active' : 'inactive'}">
                            ${staff.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>

                    <div class="profile-quick-info">
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-phone"></i>
                            <span>${empty staff.phone ? 'Chưa cập nhật' : staff.phone}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-envelope"></i>
                            <span>${empty staff.email ? 'Chưa cập nhật' : staff.email}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-briefcase"></i>
                            <span>${empty staff.position ? 'Chưa cập nhật' : staff.position}</span>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/staff" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/staff/edit/${staff.staffId}" class="btn-primary">
                            <i class="fa-solid fa-pen"></i>
                            <span>Chỉnh sửa</span>
                        </a>
                    </div>
                </div>

                <div class="profile-right-card">
                    <div class="profile-section-title">
                        <h3>Thông tin chi tiết</h3>
                    </div>

                    <div class="profile-detail-grid">
                        <div class="profile-detail-item">
                            <label>Họ tên</label>
                            <p>${empty staff.fullName ? 'Chưa cập nhật' : staff.fullName}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Số điện thoại</label>
                            <p>${empty staff.phone ? 'Chưa cập nhật' : staff.phone}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${empty staff.email ? 'Chưa cập nhật' : staff.email}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Giới tính</label>
                            <p>${empty staff.gender ? 'Chưa cập nhật' : staff.gender}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${empty staff.dob ? 'Chưa cập nhật' : staff.dob}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày vào làm</label>
                            <p>${empty staff.hireDate ? 'Chưa cập nhật' : staff.hireDate}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Chức vụ</label>
                            <p>${empty staff.position ? 'Chưa cập nhật' : staff.position}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Vai trò</label>
                            <p>
                                <c:choose>
                                    <c:when test="${staff.user != null && not empty staff.user.roleName}">
                                        ${staff.user.roleName}
                                    </c:when>
                                    <c:otherwise>
                                        Chưa cập nhật
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Trạng thái</label>
                            <p>${staff.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Lương</label>
                            <p>${empty staff.salary ? 'Chưa cập nhật' : staff.salary}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Địa chỉ</label>
                            <p>${empty staff.address ? 'Chưa cập nhật' : staff.address}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Ghi chú</label>
                            <p>${empty staff.note ? 'Chưa cập nhật' : staff.note}</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>