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
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <h2>Đổi mật khẩu</h2>

                <form method="post" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Mật khẩu hiện tại</label>
                            <input type="password" name="currentPassword">
                        </div>

                        <div class="form-group">
                            <label>Mật khẩu mới</label>
                            <input type="password" name="newPassword">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/trainer/profile" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">Đổi mật khẩu</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>