<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
            <div class="page-card form-card">
                <h2>${isEdit ? 'Cập nhật hội viên' : 'Thêm hội viên'}</h2>

                <form:form method="post" modelAttribute="member" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Tài khoản</label>
                            <select name="userId">
                                <option value="">-- Chọn tài khoản --</option>
                                <c:forEach var="u" items="${users}">
                                    <option value="${u.userId}"
                                        <c:if test="${member.user != null && member.user.userId == u.userId}">selected</c:if>>
                                            ${u.username}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullname"/>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <form:input path="phone"/>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email"/>
                        </div>

                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <form:input path="address"/>
                        </div>

                        <div class="form-group">
                            <label>Giới tính</label>
                            <form:select path="gender">
                                <form:option value="">-- Chọn --</form:option>
                                <form:option value="Nam">Nam</form:option>
                                <form:option value="Nữ">Nữ</form:option>
                                <form:option value="Khác">Khác</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <form:input path="dob" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/members" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">${isEdit ? 'Cập nhật' : 'Thêm mới'}</button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>