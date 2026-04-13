<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
            <div class="page-header">
                <div>
                    <h1>Cập nhật hồ sơ</h1>
                    <p>Chỉnh sửa thông tin tài khoản và ảnh đại diện</p>
                </div>
            </div>

            <div class="page-card form-card profile-form-card">
                <c:if test="${not empty errorMessage}">
                    <div class="alert-error">${errorMessage}</div>
                </c:if>

                <form method="post" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input id="username" type="text" name="username" value="${user.username}" required>
                            <p class="field-hint">Tên đăng nhập sẽ được cập nhật cho tài khoản hiện tại.</p>
                        </div>

                        <div class="form-group full-width">
                            <label>Avatar hiện tại</label>
                            <img class="profile-avatar-preview"
                                 src="${pageContext.request.contextPath}/uploads/${empty staff.avatar ? 'default-avatar.png' : staff.avatar}"
                                 alt="${user.username}">
                        </div>

                        <div class="form-group full-width">
                            <label for="avatarFile">Đổi avatar</label>
                            <input id="avatarFile" type="file" name="avatarFile" accept="image/*">
                            <p class="field-hint">Nếu không chọn ảnh mới, hệ thống sẽ giữ nguyên avatar hiện tại.</p>
                        </div>

                        <div class="form-group">
                            <label>Họ tên</label>
                            <input type="text" value="${staff != null ? staff.fullName : ''}" disabled>
                            <p class="field-hint">Thông tin này hiển thị từ hồ sơ staff và không chỉnh sửa tại đây.</p>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="text" value="${staff != null ? staff.email : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" value="${staff != null ? staff.phone : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Chức vụ</label>
                            <input type="text" value="${staff != null ? staff.position : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Mức lương</label>
                            <input type="text"
                                   value="<c:choose><c:when test='${staff != null && staff.salary != null}'><fmt:formatNumber value='${staff.salary}' type='number' groupingUsed='true'/> VNĐ</c:when><c:otherwise>Chưa cập nhật</c:otherwise></c:choose>"
                                   disabled>
                            <p class="field-hint">Mức lương chỉ hiển thị để tham chiếu, không được phép chỉnh sửa tại màn hình này.</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/profile" class="btn-light">
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