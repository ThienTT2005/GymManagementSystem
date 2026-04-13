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
                    <h1>${isEdit ? 'Cập nhật hội viên' : 'Thêm hội viên'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">

                <form:form method="post"
                           modelAttribute="member"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <c:if test="${isEdit}">
                        <form:hidden path="memberId"/>
                    </c:if>

                    <div class="form-grid">

                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullname"/>
                            <form:errors path="fullname" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>SĐT</label>
                            <form:input path="phone"/>
                            <form:errors path="phone" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email"/>
                            <form:errors path="email" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Giới tính</label>
                            <form:select path="gender">
                                <form:option value="">-- Chọn --</form:option>
                                <form:option value="Nam">Nam</form:option>
                                <form:option value="Nữ">Nữ</form:option>
                            </form:select>
                            <form:errors path="gender" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <form:input path="dob" type="date"/>
                            <form:errors path="dob" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng hoạt động</form:option>
                            </form:select>
                            <form:errors path="status" cssClass="error-text"/>
                        </div>

                        <div class="form-group full-width">
                            <label>Địa chỉ</label>
                            <form:input path="address"/>
                            <form:errors path="address" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Tài khoản</label>
                            <select name="userId">
                                <option value="">-- Chọn tài khoản --</option>
                                <c:forEach var="u" items="${users}">
                                    <option value="${u.userId}"
                                        ${member.user != null && member.user.userId == u.userId ? 'selected' : ''}>
                                            ${u.username}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Avatar</label>
                            <img class="preview-image"
                                 src="${pageContext.request.contextPath}/uploads/${empty member.avatar ? 'default-avatar.png' : member.avatar}"
                                 alt="Avatar hội viên">
                            <input type="file" name="avatarFile">
                        </div>

                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/members" class="btn-light">
                            Quay lại
                        </a>
                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>Lưu</span>
                        </button>
                    </div>

                </form:form>

            </div>

        </main>
    </div>
</div>
</body>
</html>