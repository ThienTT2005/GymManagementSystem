<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo hội viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-card">
                <h2 class="page-title">Tạo hội viên</h2>

                <c:if test="${not empty success}">
                    <div class="alert success-alert">${success}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert error-alert">${error}</div>
                </c:if>

                <div class="form-card">
                    <h3 class="form-title">Tạo hội viên</h3>

                    <form method="post" action="${pageContext.request.contextPath}/receptionist/create-member" class="member-form">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username (*)</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-user"></i>
                                    <input type="text" name="username" value="${username}" placeholder="Nhập username" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-envelope"></i>
                                    <input type="email" name="email" value="${email}" placeholder="Nhập email">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Password (*)</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-lock"></i>
                                    <input type="password" name="password" placeholder="Nhập password" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Địa chỉ</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <input type="text" name="address" value="${address}" placeholder="Nhập địa chỉ">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Họ tên (*)</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-user"></i>
                                    <input type="text" name="fullname" value="${fullname}" placeholder="Nhập họ tên" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Ngày sinh (*)</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-calendar"></i>
                                    <input type="date" name="dob" value="${dob}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Số điện thoại (*)</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-phone"></i>
                                    <input type="text" name="phone" value="${phone}" placeholder="Nhập số điện thoại" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Giới tính (*)</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-venus-mars"></i>
                                    <select name="gender" required>
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-submit">
                            <button type="submit" class="primary-btn">Tạo hội viên</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>