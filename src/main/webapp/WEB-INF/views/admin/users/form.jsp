<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật tài khoản' : 'Thêm tài khoản'}</h1>
                    <p>Quản lý username, password, avatar và phân quyền</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="user" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Username</label>
                            <form:input path="username"/>
                            <form:errors path="username" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Password ${isEdit ? '(để trống nếu không đổi)' : ''}</label>
                            <form:password path="password"/>
                            <form:errors path="password" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Role</label>
                            <form:select path="roleName">
                                <form:option value="ADMIN">ADMIN</form:option>
                                <form:option value="RECEPTIONIST">RECEPTIONIST</form:option>
                                <form:option value="TRAINER">TRAINER</form:option>
                                <form:option value="MEMBER">MEMBER</form:option>
                            </form:select>
                            <form:errors path="roleName" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                            <form:errors path="status" cssClass="error-text"/>
                        </div>

                        <div class="form-group full-width">
                            <label>Avatar</label>
                            <input type="file" name="avatarFile" accept="image/*">
                        </div>

                        <c:if test="${isEdit and not empty user.avatar}">
                            <div class="form-group full-width">
                                <label>Avatar hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${user.avatar}"
                                     alt="${user.username}">
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">
                            <c:choose>
                                <c:when test="${isEdit}">Cập nhật</c:when>
                                <c:otherwise>Thêm mới</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>