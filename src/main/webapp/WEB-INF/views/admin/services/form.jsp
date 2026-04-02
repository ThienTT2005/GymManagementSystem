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

        <form action="${pageContext.request.contextPath}/admin/services/save" method="post">
            <input type="hidden" name="serviceId" value="${gymService.serviceId}"/>

            <div class="form-group">
                <label>Tên dịch vụ</label>
                <input type="text" name="serviceName" value="${gymService.serviceName}" required>
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description">${gymService.description}</textarea>
            </div>

            <div class="form-group">
                <label>Tên file ảnh</label>
                <input type="text" name="image" value="${gymService.image}">
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/services">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>