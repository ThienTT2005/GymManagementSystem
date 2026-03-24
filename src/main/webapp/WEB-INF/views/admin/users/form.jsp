<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="form-box user-form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/users/save"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="userId" value="${user.userId}"/>
            <input type="hidden" name="existingAvatar" value="${user.avatar}"/>

            <div class="avatar-upload-wrap">
                <div class="avatar-preview-box">
                    <c:choose>
                        <c:when test="${not empty user.avatar}">
                            <img id="avatarPreview"
                                 src="${pageContext.request.contextPath}${user.avatar}"
                                 alt="Avatar"
                                 class="avatar-preview-img">
                        </c:when>
                        <c:otherwise>
                            <img id="avatarPreview"
                                 src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                                 alt="Avatar"
                                 class="avatar-preview-img">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="avatar-upload-actions">
                    <label class="avatar-upload-label">Ảnh đại diện</label>
                    <input type="file"
                           name="avatarFile"
                           id="avatarFile"
                           accept="image/*"
                           class="avatar-file-input">
                    <div class="text-muted">Chọn ảnh JPG, PNG hoặc WEBP</div>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" value="${user.username}" required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="text" name="password" value="${user.password}" required>
                </div>

                <div class="form-group">
                    <label>Họ tên</label>
                    <input type="text" name="fullName" value="${user.fullName}" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="${user.email}">
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="${user.phone}">
                </div>

                <div class="form-group">
                    <label>Vai trò</label>
                    <select name="role">
                        <option value="ADMIN" <c:if test="${user.role == 'ADMIN'}">selected</c:if>>ADMIN</option>
                        <option value="MEMBER" <c:if test="${user.role == 'MEMBER'}">selected</c:if>>MEMBER</option>
                        <option value="STAFF" <c:if test="${user.role == 'STAFF'}">selected</c:if>>STAFF</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="Hoạt động" <c:if test="${user.status == 'Hoạt động'}">selected</c:if>>Hoạt động</option>
                        <option value="Khóa" <c:if test="${user.status == 'Khóa'}">selected</c:if>>Khóa</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Ngày tạo</label>
                    <input type="date" name="createdDate" value="${user.createdDate}">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">
                    <i class="fa-regular fa-floppy-disk"></i> Lưu
                </button>
                <a class="btn-back" href="${pageContext.request.contextPath}/admin/users">
                    Quay lại
                </a>
            </div>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const fileInput = document.getElementById("avatarFile");
        const preview = document.getElementById("avatarPreview");

        if (fileInput && preview) {
            fileInput.addEventListener("change", function (event) {
                const file = event.target.files[0];
                if (file) {
                    preview.src = URL.createObjectURL(file);
                }
            });
        }
    });
</script>

</body>
</html>