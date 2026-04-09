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
            <div class="page-header">
                <div>
                    <h1>Đăng ký gói tập</h1>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/receptionist/memberships/create">Thêm đăng ký</a>
            </div>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/receptionist/memberships" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm hội viên">
                    </div>
                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" <c:if test="${status == 'PENDING'}">selected</c:if>>PENDING</option>
                            <option value="ACTIVE" <c:if test="${status == 'ACTIVE'}">selected</c:if>>ACTIVE</option>
                            <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>REJECTED</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-secondary">Tìm kiếm</button>
                </form>

                <table class="dashboard-table">
                    <thead>
                    <tr>
                        <th>Hội viên</th>
                        <th>Gói tập</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${membershipPage.content}">
                        <tr>
                            <td>${item.member.fullname}</td>
                            <td>${item.gymPackage.packageName}</td>
                            <td>${item.startDate}</td>
                            <td>${item.endDate}</td>
                            <td>${item.status}</td>
                            <td>
                                <c:if test="${item.status == 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/receptionist/memberships/approve/${item.membershipId}" style="display:inline-block">
                                        <button type="submit" class="btn-sm btn-approve">Duyệt</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/receptionist/memberships/reject/${item.membershipId}" style="display:inline-block">
                                        <button type="submit" class="btn-sm btn-delete">Từ chối</button>
                                    </form>
                                </c:if>
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