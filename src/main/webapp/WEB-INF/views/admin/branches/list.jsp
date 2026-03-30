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
            <div class="page-title">Quản lý chi nhánh</div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/branches/create">+ Thêm chi nhánh</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên chi nhánh</th>
                <th>Địa chỉ</th>
                <th>Số điện thoại</th>
                <th>Mô tả</th>
                <th>Ảnh</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="branch" items="${branches}">
                <tr>
                    <td>${branch.clubId}</td>
                    <td>${branch.clubName}</td>
                    <td>${branch.address}</td>
                    <td>${branch.phone}</td>
                    <td>${branch.description}</td>
                    <td>${branch.image}</td>
                    <td>
                        <a class="btn-edit" href="${pageContext.request.contextPath}/admin/branches/edit/${branch.clubId}">Sửa</a>
                        <a class="btn-delete"
                           href="${pageContext.request.contextPath}/admin/branches/delete/${branch.clubId}"
                           onclick="return confirm('Bạn có chắc muốn xóa chi nhánh này?')">Xóa</a>
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