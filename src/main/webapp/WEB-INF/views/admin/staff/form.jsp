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
                    <h1>${isEdit ? 'Cập nhật nhân viên' : 'Thêm nhân viên'}</h1>
                    <p>Nhập thông tin cá nhân và liên kết tài khoản</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="staff" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Tài khoản</label>
                            <select name="userId">
                                <option value="">-- Chọn tài khoản --</option>
                                <c:forEach var="u" items="${users}">
                                    <option value="${u.userId}"
                                        <c:if test="${staff.user != null && staff.user.userId == u.userId}">selected</c:if>>
                                            ${u.username} - ${u.roleName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullName"/>
                            <form:errors path="fullName" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <form:input path="phone"/>
                            <form:errors path="phone" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email"/>
                            <form:errors path="email" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <form:input path="address"/>
                            <form:errors path="address" cssClass="error-text"/>
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
                            <label>Chức vụ</label>
                            <form:input path="position"/>
                            <form:errors path="position" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Lương</label>
                            <form:input path="salary" type="number" step="0.01"/>
                            <form:errors path="salary" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày vào làm</label>
                            <form:input path="hireDate" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/staff" class="btn-secondary">Quay lại</a>
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