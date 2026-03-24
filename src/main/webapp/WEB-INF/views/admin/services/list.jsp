<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
    <div class="page-box">
        <div class="page-header">
            <div class="page-title">Quản lý dịch vụ</div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/services/create">+ Thêm dịch vụ</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên dịch vụ</th>
                <th>Mô tả</th>
                <th>Ảnh</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="service" items="${services}">
                <tr>
                    <td>${service.serviceId}</td>
                    <td>${service.serviceName}</td>
                    <td>${service.description}</td>
                    <td>${service.image}</td>
                    <td>
                        <a class="btn-edit" href="${pageContext.request.contextPath}/admin/services/edit/${service.serviceId}">Sửa</a>
                        <a class="btn-delete"
                           href="${pageContext.request.contextPath}/admin/services/delete/${service.serviceId}"
                           onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>