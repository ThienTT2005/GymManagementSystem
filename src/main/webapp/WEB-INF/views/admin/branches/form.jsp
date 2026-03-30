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

        <form action="${pageContext.request.contextPath}/admin/branches/save" method="post">
            <input type="hidden" name="clubId" value="${club.clubId}"/>

            <div class="form-group">
                <label>Tên chi nhánh</label>
                <input type="text" name="clubName" value="${club.clubName}" required>
            </div>

            <div class="form-group">
                <label>Địa chỉ</label>
                <input type="text" name="address" value="${club.address}" required>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone" value="${club.phone}">
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description">${club.description}</textarea>
            </div>

            <div class="form-group">
                <label>Tên file ảnh</label>
                <input type="text" name="image" value="${club.image}">
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/branches">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>