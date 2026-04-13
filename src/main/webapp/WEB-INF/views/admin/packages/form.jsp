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

            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật gói tập' : 'Thêm gói tập'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">

                <form:form method="post"
                           modelAttribute="gymPackage"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label>Tên gói *</label>
                            <form:input path="packageName"/>
                            <form:errors path="packageName" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Giá *</label>
                            <form:input path="price" type="number" min="1"/>
                        </div>

                        <div class="form-group">
                            <label>Thời hạn (tháng) *</label>
                            <form:input path="durationMonths" type="number" min="1"/>
                        </div>

                        <div class="form-group full-width">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng hoạt động</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ảnh</label>
                            <input type="file" name="imageFile">
                        </div>

                        <div class="form-group full-width">
                            <label>Mô tả</label>
                            <form:textarea path="description" rows="5"/>
                        </div>

                        <c:if test="${isEdit and not empty gymPackage.image}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${gymPackage.image}">
                            </div>
                        </c:if>

                    </div>

                    <div class="form-actions">

                        <a href="${pageContext.request.contextPath}/admin/packages" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid ${isEdit ? 'fa-floppy-disk' : 'fa-plus'}"></i>
                            <span>${isEdit ? 'Cập nhật' : 'Thêm mới'}</span>
                        </button>

                    </div>

                </form:form>

            </div>

        </main>
    </div>
</div>

</body>
</html>