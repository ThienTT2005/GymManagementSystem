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
            <div class="page-title">Quản lý lịch tập</div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/schedules/create">+ Thêm lịch tập</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Lớp học</th>
                <th>Huấn luyện viên</th>
                <th>Chi nhánh</th>
                <th>Ngày</th>
                <th>Giờ</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${schedules}">
                <tr>
                    <td>${item.scheduleId}</td>
                    <td>${item.className}</td>
                    <td>${item.trainerName}</td>
                    <td>${item.branchName}</td>
                    <td>${item.scheduleDate}</td>
                    <td>${item.scheduleTime}</td>
                    <td>
                        <c:choose>
                            <c:when test="${item.status == 'Đang mở'}">
                                <span class="status-open">${item.status}</span>
                            </c:when>
                            <c:when test="${item.status == 'Tạm dừng'}">
                                <span class="status-paused">${item.status}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-closed">${item.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a class="btn-edit" href="${pageContext.request.contextPath}/admin/schedules/edit/${item.scheduleId}">Sửa</a>
                        <a class="btn-delete"
                           href="${pageContext.request.contextPath}/admin/schedules/delete/${item.scheduleId}"
                           onclick="return confirm('Bạn có chắc muốn xóa lịch tập này?')">Xóa</a>
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