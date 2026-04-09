<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-card">
                <h2>Đăng ký tập thử</h2>

                <table class="dashboard-table">
                    <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Ngày mong muốn</th>
                        <th>Trạng thái</th>
                        <th>Cập nhật</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${trialPage.content}">
                        <tr>
                            <td>${item.fullname}</td>
                            <td>${item.phone}</td>
                            <td>${item.email}</td>
                            <td>${item.preferredDate}</td>
                            <td>${item.status}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/receptionist/trials/update-status/${item.trialId}">
                                    <select name="status">
                                        <option value="PENDING">PENDING</option>
                                        <option value="CONTACTED">CONTACTED</option>
                                        <option value="DONE">DONE</option>
                                        <option value="CANCELLED">CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn-sm btn-edit">Lưu</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
</body>
</html>