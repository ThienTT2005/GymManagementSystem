<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Lịch dạy</h1>
                    <p>Lịch dạy các lớp được phân công</p>
                </div>
            </div>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/trainer/schedule" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm lớp học / thứ">
                    </div>
                    <button type="submit" class="btn-secondary">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                </form>

                <div class="table-wrap">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Lớp học</th>
                            <th>Dịch vụ</th>
                            <th>Thứ</th>
                            <th>Giờ bắt đầu</th>
                            <th>Giờ kết thúc</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <c:forEach var="s" items="${schedules}">
                                    <tr>
                                        <td>${s.gymClass.className}</td>
                                        <td>${s.gymClass.service != null ? s.gymClass.service.serviceName : ''}</td>
                                        <td>${s.dayOfWeek}</td>
                                        <td>${s.startTime}</td>
                                        <td>${s.endTime}</td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/trainer/class-detail?id=${s.gymClass.classId}">
                                                Xem lớp
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>