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
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Cập nhật hồ sơ</h1>
                    <p>Chỉnh sửa tài khoản và ảnh đại diện huấn luyện viên</p>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card profile-form-card">
                <form method="post" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input id="username" type="text" name="username" value="${user.username}" required>
                        </div>

                        <div class="form-group">
                            <label>Vai trò</label>
                            <input type="text" value="${user.roleName}" disabled>
                        </div>

                        <div class="form-group full-width">
                            <label>Ảnh đại diện</label>
                            <div class="avatar-upload-box">
                                <div class="avatar-preview-wrap">
                                    <img class="profile-avatar-preview"
                                         src="${pageContext.request.contextPath}/uploads/${not empty trainerProfile.photo ? trainerProfile.photo : (trainerProfile != null && trainerProfile.staff != null && not empty trainerProfile.staff.avatar ? trainerProfile.staff.avatar : 'default-avatar.png')}"
                                         alt="${user.username}">
                                </div>

                                <div class="avatar-upload-actions">
                                    <input type="file" name="avatarFile" accept="image/*">
                                    <p class="field-hint">
                                        Ưu tiên ảnh hồ sơ trainer. Nếu chưa có sẽ dùng avatar của staff.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Họ tên</label>
                            <input type="text" value="${trainerProfile.staff != null ? trainerProfile.staff.fullName : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="text" value="${trainerProfile.staff != null ? trainerProfile.staff.email : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" value="${trainerProfile.staff != null ? trainerProfile.staff.phone : ''}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Chuyên môn</label>
                            <input type="text" value="${trainerProfile.specialty}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Kinh nghiệm</label>
                            <input type="text" value="${trainerProfile.experience}" disabled>
                        </div>

                        <div class="form-group">
                            <label>Mức lương</label>
                            <c:choose>
                                <c:when test="${trainerProfile != null && trainerProfile.staff != null && trainerProfile.staff.salary != null}">
                                    <input type="text"
                                           value="<fmt:formatNumber value='${trainerProfile.staff.salary}' type='number' groupingUsed='true'/> VNĐ"
                                           disabled>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" value="Chưa cập nhật" disabled>
                                </c:otherwise>
                            </c:choose>
                            <p class="field-hint">Mức lương chỉ hiển thị để tham chiếu, không được phép chỉnh sửa tại màn hình này.</p>
                        </div>

                        <div class="form-group full-width">
                            <label>Chứng chỉ</label>
                            <textarea rows="4" disabled>${trainerProfile.certifications}</textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/trainer/profile" class="btn-light">
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