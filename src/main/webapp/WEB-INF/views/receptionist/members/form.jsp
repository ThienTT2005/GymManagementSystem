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
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật hội viên' : 'Thêm hội viên'}</h1>
                </div>
            </div>

            <!-- ERROR -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="member"
                           class="admin-form">

                    <div class="form-grid">

                        <!-- ACCOUNT -->
                        <c:choose>
                            <c:when test="${!isEdit}">

                                <div class="form-group">
                                    <label>Tài khoản</label>
                                    <input type="text"
                                           name="username"
                                           value="${formUsername}"
                                           placeholder="Username đăng nhập">
                                </div>

                                <div class="form-group">
                                    <label>Mật khẩu</label>
                                    <input type="password"
                                           name="password"
                                           placeholder="Mật khẩu">
                                </div>

                            </c:when>

                            <c:otherwise>
                                <div class="form-group full-width">
                                    <label>Tài khoản</label>
                                    <input type="text"
                                           value="${member.username}"
                                           readonly>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- NAME -->
                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullname" placeholder="Nhập họ tên"/>
                            <form:errors path="fullname" cssClass="error-text"/>
                        </div>

                        <!-- PHONE -->
                        <div class="form-group">
                            <label>SĐT</label>
                            <form:input path="phone" placeholder="Nhập SĐT"/>
                            <form:errors path="phone" cssClass="error-text"/>
                        </div>

                        <!-- EMAIL -->
                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email" placeholder="Nhập email"/>
                            <form:errors path="email" cssClass="error-text"/>
                        </div>

                        <!-- ADDRESS -->
                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <form:input path="address" placeholder="Nhập địa chỉ"/>
                        </div>

                        <!-- GENDER -->
                        <div class="form-group">
                            <label>Giới tính</label>
                            <form:select path="gender">
                                <form:option value="">-- Chọn --</form:option>
                                <form:option value="Nam">Nam</form:option>
                                <form:option value="Nữ">Nữ</form:option>
                                <form:option value="Khác">Khác</form:option>
                            </form:select>
                        </div>

                        <!-- DOB -->
                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <form:input path="dob" type="date"/>
                        </div>

                        <!-- STATUS -->
                        <div class="form-group full-width">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>

                    </div>

                    <!-- ACTION -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/members"
                           class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                        </button>
                    </div>

                </form:form>
            </div>

        </main>
    </div>
</div>
</body>
</html>