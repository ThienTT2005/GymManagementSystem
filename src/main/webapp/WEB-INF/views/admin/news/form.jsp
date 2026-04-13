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
                    <h1>${isEdit ? 'Cập nhật bài viết' : 'Thêm bài viết'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">

                <form:form method="post"
                           modelAttribute="news"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label>Tiêu đề</label>
                            <form:input path="title"/>
                            <form:errors path="title" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Loại</label>
                            <form:select path="type">
                                <form:option value="NEWS">Tin tức</form:option>
                                <form:option value="PROMOTION">Khuyến mãi</form:option>
                                <form:option value="BLOG">Blog</form:option>
                                <form:option value="STORY">Câu chuyện hội viên</form:option>

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
                            <form:textarea path="content" rows="10"/>
                            <form:errors path="content" cssClass="error-text"/>
                        </div>

                        <c:if test="${isEdit and not empty news.image}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${news.image}">
                            </div>
                        </c:if>

                    </div>

                    <div class="form-actions">

                        <a href="${pageContext.request.contextPath}/admin/news" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button class="btn-primary" type="submit">
                            <i class="fa-solid fa-floppy-disk"></i>
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