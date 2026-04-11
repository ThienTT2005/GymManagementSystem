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
                    <h1>${isEdit ? 'Cập nhật dịch vụ' : 'Thêm dịch vụ'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="serviceGym"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label>Tên dịch vụ</label>
                            <form:input path="serviceName"/>
                            <form:errors path="serviceName" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Giá</label>
                            <form:input path="price" type="number" step="0.01" min="0"/>
                            <form:errors path="price" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng hoạt động</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ảnh</label>
                            <input type="file" name="imageFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Mô tả</label>
                            <form:textarea path="description" rows="5"/>
                        </div>

                        <c:if test="${isEdit and not empty serviceGym.image}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${serviceGym.image}">
                            </div>
                        </c:if>

                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/services" class="btn-light">
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