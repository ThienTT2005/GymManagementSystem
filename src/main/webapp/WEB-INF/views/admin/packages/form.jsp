<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/packages/save" method="post">
            <input type="hidden" name="packageId" value="${gymPackage.packageId}"/>

            <div class="form-group">
                <label>Tên gói tập</label>
                <input type="text" name="packageName" value="${gymPackage.packageName}" required>
            </div>

            <div class="form-group">
                <label>Thời hạn</label>
                <input type="text" name="duration" value="${gymPackage.duration}">
            </div>

            <div class="form-group">
                <label>Giá</label>
                <input type="number" step="0.01" name="price" value="${gymPackage.price}">
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description">${gymPackage.description}</textarea>
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/packages">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>