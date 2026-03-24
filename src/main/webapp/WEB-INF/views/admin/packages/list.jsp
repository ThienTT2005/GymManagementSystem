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
            <div class="page-title">Quản lý gói tập</div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/packages/create">+ Thêm gói tập</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên gói</th>
                <th>Thời hạn</th>
                <th>Giá</th>
                <th>Mô tả</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="pkg" items="${packages}">
                <tr>
                    <td>${pkg.packageId}</td>
                    <td>${pkg.packageName}</td>
                    <td>${pkg.duration}</td>
                    <td>${pkg.price}</td>
                    <td>${pkg.description}</td>
                    <td>
                        <a class="btn-edit" href="${pageContext.request.contextPath}/admin/packages/edit/${pkg.packageId}">Sửa</a>
                        <a class="btn-delete"
                           href="${pageContext.request.contextPath}/admin/packages/delete/${pkg.packageId}"
                           onclick="return confirm('Bạn có chắc muốn xóa gói tập này?')">Xóa</a>
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