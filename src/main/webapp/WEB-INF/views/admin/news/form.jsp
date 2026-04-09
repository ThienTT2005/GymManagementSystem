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
                    <h1>${isEdit ? 'Cập nhật bài viết' : 'Thêm bài viết'}</h1>
                    <p>Nhập thông tin tin tức / khuyến mãi</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="news" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Tiêu đề</label>
                            <form:input path="title"/>
                            <form:errors path="title" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Loại bài viết</label>
                            <form:select path="type">
                                <form:option value="NEWS">NEWS</form:option>
                                <form:option value="PROMOTION">PROMOTION</form:option>
                                <form:option value="BLOG">BLOG</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hiển thị</form:option>
                                <form:option value="0">Ẩn</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ảnh</label>
                            <input type="file" name="imageFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Nội dung</label>
                            <form:textarea path="content" rows="12"/>
                            <form:errors path="content" cssClass="error-text"/>
                        </div>

                        <c:if test="${isEdit and not empty news.image}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/assets/images/${news.image}"
                                     alt="${news.title}">
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/news" class="btn-secondary">Quay lại</a>
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