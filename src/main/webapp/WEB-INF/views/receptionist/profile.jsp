<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

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
                        <p><strong>Trạng thái:</strong> ${user.status == 1 ? 'Hoạt động' : 'Ngừng'}</p>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/receptionist/profile/edit" class="btn-primary">Cập nhật hồ sơ</a>
                    <a href="${pageContext.request.contextPath}/receptionist/profile/change-password" class="btn-secondary">Đổi mật khẩu</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>