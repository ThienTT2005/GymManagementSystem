<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ttt.css">
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
                </div>
            </div>

            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/trainer/schedule"
                      class="filter-form">

                    <div class="filter-group filter-group-grow">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Lớp / dịch vụ / thứ">
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>

                        <a href="${pageContext.request.contextPath}/trainer/schedule" class="btn-light">
                            <i class="fa-solid fa-rotate-right"></i>
                        </a>
                    </div>
                </form>
            </div>

            <div class="page-card">
                <div class="table-responsive">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>Lớp</th>
                            <th>Dịch vụ</th>
                            <th>Thứ</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th></th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <c:forEach var="s" items="${schedules}">
                                    <tr>
                                        <td>${s.gymClass != null ? s.gymClass.className : '---'}</td>
                                        <td>${s.gymClass != null && s.gymClass.service != null ? s.gymClass.service.serviceName : '---'}</td>
                                        <td>${empty s.dayOfWeek ? '---' : s.dayOfWeek}</td>
                                        <td>${empty s.startTime ? '---' : s.startTime}</td>
                                        <td>${empty s.endTime ? '---' : s.endTime}</td>
                                        <td>
                                            <a class="btn-sm btn-light"
                                               href="${pageContext.request.contextPath}/trainer/class-detail?id=${s.gymClass.classId}"
                                               title="Xem lớp">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có lịch dạy</td>
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