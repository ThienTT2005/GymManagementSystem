<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Dashboard Admin</h1>
                    <p>Trung tâm điều hành và theo dõi hệ thống gym</p>
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
                    <div class="stat-icon"><i class="fa-solid fa-id-badge"></i></div>
                    <div class="stat-content">
                        <h3>${totalStaff}</h3>
                        <p>Nhân viên</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-dumbbell"></i></div>
                    <div class="stat-content">
                        <h3>${totalClasses}</h3>
                        <p>Lớp học</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fa-solid fa-box-open"></i></div>
                    <div class="stat-content">
                        <h3>${totalPackages}</h3>
                        <p>Gói tập</p>
                    </div>
                </div>

                <div class="stat-card revenue-card">
                    <div class="stat-icon"><i class="fa-solid fa-money-bill-wave"></i></div>
                    <div class="stat-content">
                        <h3><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> đ</h3>
                        <p>Doanh thu</p>
                    </div>
                </div>
            </section>

            <section class="alert-grid">
                <a class="alert-card" href="${pageContext.request.contextPath}/admin/memberships">
                    <h4>${pendingMembershipCount}</h4>
                    <p>Gói tập chờ duyệt</p>
                </a>

                <a class="alert-card" href="${pageContext.request.contextPath}/admin/class-registrations">
                    <h4>${pendingClassRegistrationCount}</h4>
                    <p>Lớp học chờ duyệt</p>
                </a>

                <a class="alert-card" href="${pageContext.request.contextPath}/admin/payments">
                    <h4>${pendingPayments}</h4>
                    <p>Thanh toán chờ duyệt</p>
                </a>

                <a class="alert-card" href="${pageContext.request.contextPath}/admin/trials">
                    <h4>${pendingTrialCount}</h4>
                    <p>Tập thử chờ xử lý</p>
                </a>

                <a class="alert-card" href="${pageContext.request.contextPath}/admin/contacts">
                    <h4>${pendingConsultationCount}</h4>
                    <p>Tư vấn chờ xử lý</p>
                </a>
            </section>

            <section class="quick-actions">
                <a href="${pageContext.request.contextPath}/admin/members/create" class="action-btn">
                    <i class="fa-solid fa-user-plus"></i> Thêm hội viên
                </a>
                <a href="${pageContext.request.contextPath}/admin/staff/create" class="action-btn">
                    <i class="fa-solid fa-id-card"></i> Thêm nhân viên
                </a>
                <a href="${pageContext.request.contextPath}/admin/trainers/create" class="action-btn">
                    <i class="fa-solid fa-person-running"></i> Thêm trainer
                </a>
                <a href="${pageContext.request.contextPath}/admin/classes/create" class="action-btn">
                    <i class="fa-solid fa-dumbbell"></i> Thêm lớp học
                </a>
            </section>

            <section class="dashboard-charts">
                <div class="dashboard-panel chart-panel">
                    <div class="panel-header">
                        <h3>Doanh thu theo tháng</h3>
                    </div>
                    <div class="chart-wrap">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <div class="dashboard-panel chart-panel">
                    <div class="panel-header">
                        <h3>Top gói tập được đăng ký</h3>
                    </div>
                    <div class="chart-wrap">
                        <canvas id="packageChart"></canvas>
                    </div>
                </div>
            </section>

            <section class="dashboard-panels">
                <div class="dashboard-panel">
                    <div class="panel-header">
                        <h3>Top lớp học đông người</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Lớp học</th>
                                <th>Hiện tại</th>
                                <th>Tối đa</th>
                                <th>Lấp đầy</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty topClasses}">
                                    <c:forEach var="item" items="${topClasses}">
                                        <tr>
                                            <td>${item.className}</td>
                                            <td>${item.currentMember}</td>
                                            <td>${item.maxMember}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.maxMember > 0}">
                                                        <fmt:formatNumber value="${(item.currentMember * 100.0) / item.maxMember}" maxFractionDigits="0"/>%
                                                    </c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-cell">Chưa có dữ liệu</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="dashboard-panel">
                    <div class="panel-header">
                        <h3>Top gói tập phổ biến</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Gói tập</th>
                                <th>Lượt đăng ký</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty topPackages}">
                                    <c:forEach var="item" items="${topPackages}">
                                        <tr>
                                            <td>${item.packageName}</td>
                                            <td>${item.totalRegistrations}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="2" class="empty-cell">Chưa có dữ liệu</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>

<script>
    const revenueLabels = [
        <c:forEach var="item" items="${monthlyRevenue}" varStatus="loop">
            '${item.monthLabel}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const revenueValues = [
        <c:forEach var="item" items="${monthlyRevenue}" varStatus="loop">
            ${item.totalRevenue}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const packageLabels = [
        <c:forEach var="item" items="${topPackages}" varStatus="loop">
            '${item.packageName}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const packageValues = [
        <c:forEach var="item" items="${topPackages}" varStatus="loop">
            ${item.totalRegistrations}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const revenueCtx = document.getElementById('revenueChart');
    if (revenueCtx) {
        new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenueValues,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }

    const packageCtx = document.getElementById('packageChart');
    if (packageCtx) {
        new Chart(packageCtx, {
            type: 'doughnut',
            data: {
                labels: packageLabels,
                datasets: [{
                    data: packageValues,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }
</script>

</body>
</html>