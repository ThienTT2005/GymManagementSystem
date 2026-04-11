<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                    <h1>Cập nhật hồ sơ quản trị viên</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form method="post" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input id="username" type="text" name="username" value="${user.username}" required>
                        </div>

                        <div class="form-group">
                            <label for="fullName">Họ tên</label>
                            <input id="fullName" type="text" name="fullName"
                                   value="${empty staff ? '' : staff.fullName}">
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input id="email" type="email" name="email"
                                   value="${empty staff ? '' : staff.email}">
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input id="phone" type="text" name="phone"
                                   value="${empty staff ? '' : staff.phone}">
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Địa chỉ</label>
                            <input id="address" type="text" name="address"
                                   value="${empty staff ? '' : staff.address}">
                        </div>

                        <div class="form-group">
                            <label for="gender">Giới tính</label>
                            <select id="gender" name="gender">
                                <option value="">-- Chọn giới tính --</option>
                                <option value="Nam" ${not empty staff and staff.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${not empty staff and staff.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${not empty staff and staff.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dob">Ngày sinh</label>
                            <input id="dob" type="date" name="dob"
                                   value="${empty staff or empty staff.dob ? '' : staff.dob}">
                        </div>

                        <div class="form-group full-width">
                            <label for="avatarFile">Ảnh đại diện</label>
                            <input id="avatarFile" type="file" name="avatarFile" accept="image/*">
                            <p class="field-hint">Nếu không chọn ảnh mới, hệ thống sẽ giữ ảnh hiện tại.</p>
                        </div>

                        <div class="form-group full-width">
                            <label>Ảnh hiện tại</label>
                            <img class="preview-image"
                                 src="${empty staff or empty staff.avatar ? pageContext.request.contextPath.concat('/assets/images/default-avatar.png') : pageContext.request.contextPath.concat('/uploads/').concat(staff.avatar)}"
                                 alt="${user.username}">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/profile" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>Cập nhật</span>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>