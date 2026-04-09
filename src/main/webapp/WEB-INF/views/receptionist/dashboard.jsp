<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Dashboard Receptionist</h1>
                    <p>Quản lý vận hành hội viên, gói tập, lớp học và yêu cầu khách hàng</p>
                </div>
            </div>

            <section class="stats-grid dashboard-stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="stat-content">
                        <h3>${totalMembers}</h3>
                        <p>Hội viên</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-address-card"></i></div>
                    <div class="stat-content">
                        <h3>${pendingMemberships}</h3>
                        <p>Gói tập chờ duyệt</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-list-check"></i></div>
                    <div class="stat-content">
                        <h3>${pendingClassRegistrations}</h3>
                        <p>Lớp học chờ duyệt</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-money-check-dollar"></i></div>
                    <div class="stat-content">
                        <h3>${pendingPayments}</h3>
                        <p>Thanh toán chờ duyệt</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-stopwatch"></i></div>
                    <div class="stat-content">
                        <h3>${pendingTrials}</h3>
                        <p>Tập thử chờ xử lý</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-comments"></i></div>
                    <div class="stat-content">
                        <h3>${pendingConsultations}</h3>
                        <p>Tư vấn chờ xử lý</p>
                    </div>
                </div>
            </section>

            <section class="dashboard-panels">
                <div class="dashboard-panel">
                    <div class="panel-header">
                        <h3>Đăng ký gói tập gần đây</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Hội viên</th>
                                <th>Gói tập</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${recentMemberships}">
                                <tr>
                                    <td>${item.member.fullname}</td>
                                    <td>${item.gymPackage.packageName}</td>
                                    <td>${item.status}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="dashboard-panel">
                    <div class="panel-header">
                        <h3>Đăng ký lớp gần đây</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Hội viên</th>
                                <th>Lớp</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${recentClassRegistrations}">
                                <tr>
                                    <td>${item.member.fullname}</td>
                                    <td>${item.gymClass.className}</td>
                                    <td>${item.status}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>