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
                    <h1>${isEdit ? 'Cập nhật gói tập' : 'Thêm gói tập'}</h1>
                    <p>Nhập thông tin gói tập</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="gymPackage" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Tên gói tập</label>
                            <form:input path="packageName"/>
                            <form:errors path="packageName" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Giá</label>
                            <form:input path="price" type="number" step="0.01" min="0"/>
                            <form:errors path="price" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Thời hạn (ngày)</label>
                            <form:input path="durationDays" type="number" min="1"/>
                            <form:errors path="durationDays" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng hoạt động</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label>Ảnh</label>
                            <input type="file" name="imageFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Mô tả</label>
                            <form:textarea path="description" rows="5"/>
                        </div>

                        <c:if test="${isEdit and not empty gymPackage.image}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/assets/images/${gymPackage.image}"
                                     alt="${gymPackage.packageName}">
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/packages" class="btn-secondary">Quay lại</a>
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