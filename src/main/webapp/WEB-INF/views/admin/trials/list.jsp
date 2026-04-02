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
            <div class="page-title">Đăng ký tập thử</div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/trials/create">+ Thêm đăng ký</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Họ tên</th>
                <th>Số điện thoại</th>
                <th>Email</th>
                <th>Chi nhánh</th>
                <th>Ngày đăng ký</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${trialList}">
                <tr>
                    <td>${item.trialId}</td>
                    <td>${item.fullName}</td>
                    <td>${item.phone}</td>
                    <td>${item.email}</td>
                    <td>${item.branchName}</td>
                    <td>${item.registerDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${item.status == 'Đã liên hệ'}">
                                <span class="status-done">${item.status}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-wait">${item.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a class="btn-edit" href="${pageContext.request.contextPath}/admin/trials/edit/${item.trialId}">Sửa</a>
                        <a class="btn-delete"
                           href="${pageContext.request.contextPath}/admin/trials/delete/${item.trialId}"
                           onclick="return confirm('Bạn có chắc muốn xóa đăng ký này?')">Xóa</a>
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