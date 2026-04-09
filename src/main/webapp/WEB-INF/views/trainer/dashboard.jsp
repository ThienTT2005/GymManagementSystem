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
                    <h1>Dashboard Trainer</h1>
                    <p>Theo dõi lớp học, lịch dạy và học viên đang phụ trách</p>
                </div>
            </div>

            <section class="stats-grid dashboard-stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-dumbbell"></i></div>
                    <div class="stat-content">
                        <h3>${classCount}</h3>
                        <p>Lớp đang phụ trách</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-calendar-days"></i></div>
                    <div class="stat-content">
                        <h3>${scheduleCount}</h3>
                        <p>Lịch dạy</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="stat-content">
                        <h3>${activeStudentCount}</h3>
                        <p>Học viên đang học</p>
                    </div>
                </div>
            </section>

            <section class="dashboard-panel">
                <div class="panel-header">
                    <h3>Lịch dạy sắp tới</h3>
                </div>

                <div class="table-wrap">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Lớp học</th>
                            <th>Dịch vụ</th>
                            <th>Thứ</th>
                            <th>Giờ</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty upcomingSchedules}">
                                <c:forEach var="s" items="${upcomingSchedules}">
                                    <tr>
                                        <td>${s.gymClass.className}</td>
                                        <td>${s.gymClass.service != null ? s.gymClass.service.serviceName : ''}</td>
                                        <td>${s.dayOfWeek}</td>
                                        <td>${s.startTime} - ${s.endTime}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="empty-cell">Chưa có lịch dạy</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>