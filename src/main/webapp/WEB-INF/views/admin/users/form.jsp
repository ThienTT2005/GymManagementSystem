<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
                    <h1>${isEdit ? 'Cập nhật tài khoản' : 'Thêm tài khoản'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="user"
                           class="admin-form">

                    <c:if test="${isEdit}">
                        <form:hidden path="userId"/>
                    </c:if>

                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label for="username">Username</label>
                            <form:input path="username" id="username" placeholder="Nhập tên đăng nhập"/>
                            <form:errors path="username" cssClass="error-text"/>
                        </div>

                        <div class="form-group full-width">
                            <label for="password">Mật khẩu</label>
                            <form:password path="password" id="password" placeholder="${isEdit ? 'Để trống nếu không đổi mật khẩu' : 'Nhập mật khẩu'}"/>
                            <small class="text-muted">${isEdit ? 'Để trống nếu không đổi mật khẩu' : 'Bắt buộc'}</small>
                            <form:errors path="password" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="roleId">Quyền</label>
                            <form:select path="roleId" id="roleId">
                                <form:option value="">-- Chọn quyền --</form:option>
                                <c:forEach var="r" items="${roles}">
                                    <form:option value="${r.roleId}">${r.roleName}</form:option>
                                </c:forEach>
                            </form:select>
                            <form:errors path="roleId" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="status">Trạng thái</label>
                            <form:select path="status" id="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Đã khóa</form:option>
                            </form:select>
                            <form:errors path="status" cssClass="error-text"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>${isEdit ? 'Cập nhật' : 'Lưu'}</span>
                        </button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>