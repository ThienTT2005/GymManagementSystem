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
    <div class="form-box news-form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/news/save"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="postId" value="${news.postId}"/>
            <input type="hidden" name="existingImage" value="${news.image}"/>

            <div class="form-group">
                <label>Tiêu đề</label>
                <input type="text" name="title" value="${news.title}" required>
            </div>

            <div class="form-group">
                <label>Nội dung</label>
                <textarea name="content">${news.content}</textarea>
            </div>

            <div class="form-group">
                <label>Danh mục</label>
                <select name="category" required>
                    <option value="" disabled ${empty news.category ? 'selected' : ''}>-- Chọn danh mục --</option>
                    <option value="BLOG" ${news.category == 'BLOG' ? 'selected' : ''}>BLOG</option>
                    <option value="CAU_CHUYEN_HOI_VIEN" ${news.category == 'CAU_CHUYEN_HOI_VIEN' ? 'selected' : ''}>CÂU CHUYỆN HỘI VIÊN</option>
                    <option value="KHUYEN_MAI" ${news.category == 'KHUYEN_MAI' ? 'selected' : ''}>KHUYẾN MÃI</option>
                </select>
            </div>

            <div class="form-group">
                <label>Ảnh tin tức</label>
                <input type="file"
                       name="imageFile"
                       id="imageFile"
                       accept="image/*">
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/news">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const fileInput = document.getElementById("imageFile");
        const preview = document.getElementById("newsPreview");

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