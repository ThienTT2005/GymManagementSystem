<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa hội viên</title>
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
                <h2 class="page-title">Sửa hội viên</h2>

                <c:if test="${not empty error}">
                    <div class="alert error-alert">${error}</div>
                </c:if>

                <div class="form-card">
                    <h3 class="form-title">Cập nhật thông tin hội viên</h3>

                    <form method="post" action="${pageContext.request.contextPath}/receptionist/edit-member" class="member-form">
                        <input type="hidden" name="memberId" value="${member.memberId}">

                        <div class="form-grid">
                            <div class="form-group">
                                <label>Họ tên (*)</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-user"></i>
                                    <input type="text" name="fullname" value="${member.fullname}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-envelope"></i>
                                    <input type="email" name="email" value="${member.email}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Số điện thoại (*)</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-phone"></i>
                                    <input type="text" name="phone" value="${member.phone}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Địa chỉ</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <input type="text" name="address" value="${member.address}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Ngày sinh (*)</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-calendar"></i>
                                    <input type="date" name="dob" value="${member.dob}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Giới tính (*)</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-venus-mars"></i>
                                    <select name="gender" required>
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam" ${member.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${member.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${member.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-submit multi-btn">
                            <a href="${pageContext.request.contextPath}/receptionist/member-detail?id=${member.memberId}" class="secondary-btn">
                                Hủy
                            </a>

                            <button type="submit" class="primary-btn">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>