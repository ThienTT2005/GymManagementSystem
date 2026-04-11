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

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật nhân viên' : 'Thêm nhân viên'}</h1>
                </div>
            </div>

            <!-- ERROR -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="staff"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <c:if test="${isEdit}">
                        <form:hidden path="staffId"/>
                        <input type="hidden" name="currentAvatar" value="${staff.avatar}">
                    </c:if>

                    <div class="form-grid">

                        <!-- USER -->
                        <div class="form-group full-width">
                            <label>Tài khoản</label>
                            <select name="userId" id="userId">
                                <option value="">-- Chọn --</option>
                                <c:forEach var="u" items="${users}">
                                    <option value="${u.userId}"
                                            data-role="${u.roleName}"
                                            <c:if test="${staff.user != null && staff.user.userId == u.userId}">selected</c:if>>
                                        ${u.username} (${u.roleName})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- NAME -->
                        <div class="form-group">
                            <label>Họ tên</label>
                            <form:input path="fullName" placeholder="Nhập họ tên"/>
                        </div>

                        <!-- PHONE -->
                        <div class="form-group">
                            <label>SĐT</label>
                            <form:input path="phone" placeholder="Nhập số điện thoại"/>
                        </div>

                        <!-- EMAIL -->
                        <div class="form-group">
                            <label>Email</label>
                            <form:input path="email" placeholder="Nhập email"/>
                        </div>

                        <!-- POSITION -->
                        <div class="form-group">
                            <label>Chức vụ</label>
                            <form:input path="position" id="position" readonly="true"/>
                            <small class="text-muted">Tự động theo role</small>
                        </div>

                        <!-- SALARY -->
                        <div class="form-group">
                            <label>Lương</label>
                            <form:input path="salary" type="number" step="0.01" placeholder="0"/>
                        </div>

                        <!-- STATUS -->
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>

                        <!-- AVATAR -->
                        <div class="form-group full-width">
                            <label>Ảnh</label>
                            <input type="file" name="avatarFile" accept="image/*">
                            <small class="text-muted">Upload ảnh (tùy chọn)</small>
                        </div>

                        <!-- ADDRESS -->
                        <div class="form-group full-width">
                            <label>Địa chỉ</label>
                            <form:input path="address" placeholder="Nhập địa chỉ"/>
                        </div>

                        <!-- NOTE -->
                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="3" placeholder="Ghi chú..."/>
                        </div>

                        <!-- CURRENT IMAGE -->
                        <c:if test="${isEdit and not empty staff.avatar}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/${staff.avatar.startsWith('assets/') ? staff.avatar : 'uploads/'.concat(staff.avatar)}"
                                     alt="${staff.fullName}">
                            </div>
                        </c:if>

                    </div>

                    <!-- ACTION -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/staff"
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

<!-- AUTO POSITION -->
<script>
    (function () {
        const userSelect = document.getElementById('userId');
        const positionInput = document.getElementById('position');

        function mapRoleToPosition(roleName) {
            if (!roleName) return '';
            const role = roleName.trim().toUpperCase();

            if (role === 'ADMIN') return 'Manager';
            if (role === 'RECEPTIONIST') return 'Receptionist';
            if (role === 'TRAINER') return 'Trainer';
            return '';
        }

        function syncPosition() {
            const selected = userSelect.options[userSelect.selectedIndex];
            const role = selected ? selected.getAttribute('data-role') : '';
            positionInput.value = mapRoleToPosition(role);
        }

        if (userSelect) {
            userSelect.addEventListener('change', syncPosition);
            syncPosition();
        }
    })();
</script>

</body>
</html>