<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
            <div class="page-card form-card">
                <h2>Cập nhật hồ sơ</h2>

                <form method="post" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" value="${user.username}">
                        </div>

                        <div class="form-group full-width">
                            <label>Avatar tài khoản</label>
                            <input type="file" name="avatarFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Avatar hiện tại</label>
                            <img class="preview-image"
                                 src="${pageContext.request.contextPath}/uploads/${empty user.avatar ? 'default-avatar.png' : user.avatar}"
                                 alt="${user.username}">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/trainer/profile" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>