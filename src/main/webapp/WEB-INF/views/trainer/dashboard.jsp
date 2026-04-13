<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ttt.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .dashboard-stats-grid .stat-card:nth-child(1) {
            background: linear-gradient(135deg, #b40000 0%, #d31313 58%, #ef4444 100%);
        }

        .dashboard-stats-grid .stat-card:nth-child(2) {
            background: linear-gradient(135deg, #9f1239 0%, #c81e1e 55%, #ef4444 100%);
        }

        .dashboard-stats-grid .stat-card:nth-child(3) {
            background: linear-gradient(135deg, #991b1b 0%, #dc2626 52%, #f87171 100%);
        }

        .dashboard-stats-grid .stat-card {
            position: relative;
            overflow: hidden;
            border: none;
        }

        .dashboard-stats-grid .stat-card::before {
            content: "";
            position: absolute;
            right: -22px;
            bottom: -26px;
            width: 108px;
            height: 108px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.10);
        }

        .dashboard-stats-grid .stat-card::after {
            content: "";
            position: absolute;
            right: 18px;
            top: 18px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
        }

        .dashboard-stats-grid .stat-card .stat-title,
        .dashboard-stats-grid .stat-card .stat-title i,
        .dashboard-stats-grid .stat-card .stat-title span,
        .dashboard-stats-grid .stat-card .stat-value {
            color: #ffffff;
            position: relative;
            z-index: 1;
        }

        .dashboard-stats-grid .stat-card .stat-title {
            opacity: 0.96;
        }

        .dashboard-stats-grid .stat-card .stat-value {
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.12);
        }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Bảng điều khiển huấn luyện viên</h1>
                    <p>Theo dõi lịch dạy, lớp phụ trách và học viên đang quản lý</p>
                </div>
            </div>

            <section class="stats-grid dashboard-stats-grid">
                <div class="stat-card">
                    <div class="stat-title">
                        <i class="fa-solid fa-dumbbell"></i>
                        <span>Lớp phụ trách</span>
                    </div>
                    <div class="stat-value">${classCount}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-title">
                        <i class="fa-solid fa-calendar-days"></i>
                        <span>Lịch dạy</span>
                    </div>
                    <div class="stat-value">${scheduleCount}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-title">
                        <i class="fa-solid fa-users"></i>
                        <span>Học viên đang học</span>
                    </div>
                    <div class="stat-value">${activeStudentCount}</div>
                </div>
            </section>

            <div class="dashboard-grid">

                <section class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Lịch dạy sắp tới</h3>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Lớp học</th>
                                <th>Dịch vụ</th>
                                <th>Thứ</th>
                                <th>Giờ học</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty upcomingSchedules}">
                                    <c:forEach var="s" items="${upcomingSchedules}">
                                        <tr>
                                            <td>${s.gymClass.className}</td>
                                            <td>${s.gymClass.service != null ? s.gymClass.service.serviceName : '-'}</td>
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

                <section class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Lớp đang phụ trách</h3>
                        <a class="view-all-link" href="${pageContext.request.contextPath}/trainer/classes">Xem tất cả</a>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Tên lớp</th>
                                <th>Dịch vụ</th>
                                <th>Học viên hiện tại</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty trainerClasses}">
                                    <c:forEach var="c" items="${trainerClasses}">
                                        <tr>
                                            <td>${c.className}</td>
                                            <td>${c.service != null ? c.service.serviceName : '-'}</td>
                                            <td>${c.currentMember}</td>
                                            <td>
                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/trainer/class-detail?id=${c.classId}">
                                                    <i class="fa-solid fa-eye"></i>
                                                    <span>Xem lớp</span>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-cell">Chưa có lớp phụ trách</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

            </div>
        </main>
    </div>
</div>
</body>
</html>