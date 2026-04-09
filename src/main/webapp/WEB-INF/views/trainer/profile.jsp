<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <div class="page-card">
                <h2>Hồ sơ cá nhân</h2>

                <div class="profile-box">
                    <img class="profile-avatar"
                         src="${pageContext.request.contextPath}/uploads/${empty user.avatar ? 'default-avatar.png' : user.avatar}"
                         alt="${user.username}">

                    <div class="profile-info">
                        <p><strong>Username:</strong> ${user.username}</p>
                        <p><strong>Vai trò:</strong> ${user.roleName}</p>

                        <c:if test="${trainerProfile != null && trainerProfile.staff != null}">
                            <p><strong>Họ tên:</strong> ${trainerProfile.staff.fullName}</p>
                            <p><strong>Số điện thoại:</strong> ${trainerProfile.staff.phone}</p>
                            <p><strong>Email:</strong> ${trainerProfile.staff.email}</p>
                            <p><strong>Chức vụ:</strong> ${trainerProfile.staff.position}</p>
                        </c:if>

                        <p><strong>Trạng thái:</strong> ${user.status == 1 ? 'Hoạt động' : 'Ngừng'}</p>
                    </div>
                </div>

                <c:if test="${trainerProfile != null}">
                    <div class="detail-section">
                        <h3>Thông tin chuyên môn</h3>
                        <p><strong>Chuyên môn:</strong> ${trainerProfile.specialty}</p>
                        <p><strong>Kinh nghiệm:</strong> ${trainerProfile.experience}</p>
                        <p><strong>Chứng chỉ:</strong> ${trainerProfile.certifications}</p>

                        <c:if test="${not empty trainerProfile.photo}">
                            <div style="margin-top: 12px;">
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${trainerProfile.photo}"
                                     alt="${trainerProfile.staffName}">
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/trainer/edit-profile" class="btn-primary">Cập nhật hồ sơ</a>
                    <a href="${pageContext.request.contextPath}/trainer/change-password" class="btn-secondary">Đổi mật khẩu</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>