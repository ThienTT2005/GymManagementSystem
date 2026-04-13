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
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Đổi mật khẩu</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card password-card">
                <form method="post" class="admin-form password-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label for="currentPassword">Mật khẩu hiện tại</label>
                            <input id="currentPassword" type="password" name="currentPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới</label>
                            <input id="newPassword" type="password" name="newPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                            <input id="confirmPassword" type="password" name="confirmPassword" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/profile" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-key"></i>
                            <span>Đổi mật khẩu</span>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>