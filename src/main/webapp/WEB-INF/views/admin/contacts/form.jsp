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
                    <h1>${isEdit ? 'Cập nhật đăng ký tư vấn' : 'Thêm đăng ký tư vấn'}</h1>
                    <p>Nhập thông tin khách cần tư vấn</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="consultation" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullname"/>
                            <form:errors path="fullname" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <form:input path="phone"/>
                            <form:errors path="phone" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email" type="email"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="PENDING">PENDING</form:option>
                                <form:option value="CONTACTED">CONTACTED</form:option>
                                <form:option value="DONE">DONE</form:option>
                                <form:option value="CANCELLED">CANCELLED</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Nội dung tư vấn</label>
                            <form:textarea path="message" rows="5"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="btn-secondary">Quay lại</a>
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