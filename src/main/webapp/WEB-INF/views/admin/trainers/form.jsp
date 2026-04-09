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
                    <h1>${isEdit ? 'Cập nhật huấn luyện viên' : 'Thêm huấn luyện viên'}</h1>
                    <p>Nhập thông tin hồ sơ trainer</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="trainer" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Nhân viên</label>
                            <select name="staffId">
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="s" items="${staffs}">
                                    <option value="${s.staffId}"
                                        <c:if test="${trainer.staff != null && trainer.staff.staffId == s.staffId}">selected</c:if>>
                                            ${s.fullName} - ${s.position}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label>Chuyên môn</label>
                            <form:input path="specialty"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label>Ảnh hồ sơ trainer</label>
                            <input type="file" name="photoFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Kinh nghiệm</label>
                            <form:textarea path="experience" rows="4"/>
                        </div>

                        <div class="form-group full-width">
                            <label>Chứng chỉ</label>
                            <form:textarea path="certifications" rows="4"/>
                        </div>

                        <c:if test="${isEdit and not empty trainer.photo}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${trainer.photo}"
                                     alt="${trainer.staffName}">
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/trainers" class="btn-secondary">Quay lại</a>
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