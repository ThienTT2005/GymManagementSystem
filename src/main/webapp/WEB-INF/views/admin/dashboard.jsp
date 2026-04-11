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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Bảng điều khiển quản trị</h1>
                </div>
            </div>

            <section class="stats-grid dashboard-stats-grid">
                <a class="stat-card stat-card-link stat-card-variant-1"
                   href="${pageContext.request.contextPath}/admin/members">
                    <div class="stat-title">
                        <i class="fa-solid fa-users"></i>
                        <span>Tổng hội viên</span>
                    </div>
                    <div class="stat-value">${totalMembers}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-2"
                   href="${pageContext.request.contextPath}/admin/staff">
                    <div class="stat-title">
                        <i class="fa-solid fa-user-tie"></i>
                        <span>Tổng nhân viên</span>
                    </div>
                    <div class="stat-value">${totalStaff}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-3"
                   href="${pageContext.request.contextPath}/admin/trainers">
                    <div class="stat-title">
                        <i class="fa-solid fa-dumbbell"></i>
                        <span>Tổng huấn luyện viên</span>
                    </div>
                    <div class="stat-value">${totalTrainers}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-4"
                   href="${pageContext.request.contextPath}/admin/classes">
                    <div class="stat-title">
                        <i class="fa-solid fa-people-group"></i>
                        <span>Tổng lớp học</span>
                    </div>
                    <div class="stat-value">${totalClasses}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-5"
                   href="${pageContext.request.contextPath}/admin/packages">
                    <div class="stat-title">
                        <i class="fa-solid fa-box-open"></i>
                        <span>Tổng gói tập</span>
                    </div>
                    <div class="stat-value">${totalPackages}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-6"
                   href="${pageContext.request.contextPath}/admin/trials">
                    <div class="stat-title">
                        <i class="fa-solid fa-stopwatch"></i>
                        <span>Tổng đăng ký tập thử</span>
                    </div>
                    <div class="stat-value">${totalTrials}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-7"
                   href="${pageContext.request.contextPath}/admin/contacts">
                    <div class="stat-title">
                        <i class="fa-solid fa-headset"></i>
                        <span>Tổng yêu cầu tư vấn</span>
                    </div>
                    <div class="stat-value">${totalConsultations}</div>
                </a>

                <a class="stat-card stat-card-link stat-card-variant-8"
                   href="${pageContext.request.contextPath}/admin/reports">
                    <div class="stat-title">
                        <i class="fa-solid fa-sack-dollar"></i>
                        <span>Tổng doanh thu</span>
                    </div>
                    <div class="stat-value stat-value-money">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                    </div>
                </a>
            </section>

            <section class="chart-grid dashboard-chart-grid">
                <div class="chart-box">
                    <div class="chart-box-header">
                        <h3>Doanh thu theo tháng</h3>
                    </div>
                    <div class="chart-canvas-wrap chart-canvas-wrap-bar">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <div class="chart-box chart-box-pie">
                    <div class="chart-box-header">
                        <h3>Phân bố thanh toán</h3>
                    </div>
                    <div class="chart-canvas-wrap chart-canvas-wrap-pie">
                        <canvas id="paymentStatusChart"></canvas>
                    </div>
                </div>
            </section>

            <section class="dashboard-grid">
                <div class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Đăng ký gói gần đây</h3>
                        <a class="view-all-link" href="${pageContext.request.contextPath}/admin/memberships">Xem tất cả</a>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Hội viên</th>
                                <th>Gói tập</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentMemberships}">
                                    <c:forEach var="m" items="${recentMemberships}">
                                        <tr>
                                            <td>${m.member.fullname}</td>
                                            <td>${m.gymPackage.packageName}</td>
                                            <td>
                                                <span class="status-badge ${m.status eq 'ACTIVE' or m.status eq 'Hoạt động' ? 'active' :
                                                                             (m.status eq 'INACTIVE' or m.status eq 'Ngừng hoạt động' ? 'inactive' : 'pending')}">
                                                    ${m.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="empty-cell">Không có dữ liệu gần đây</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Đăng ký lớp gần đây</h3>
                        <a class="view-all-link" href="${pageContext.request.contextPath}/admin/class-registrations">Xem tất cả</a>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Hội viên</th>
                                <th>Lớp học</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentClassRegistrations}">
                                    <c:forEach var="r" items="${recentClassRegistrations}">
                                        <tr>
                                            <td>${r.member.fullname}</td>
                                            <td>${r.gymClass.className}</td>
                                            <td>
                                                <span class="status-badge ${r.status eq 'ACTIVE' or r.status eq 'Hoạt động' ? 'active' :
                                                                             (r.status eq 'INACTIVE' or r.status eq 'Ngừng hoạt động' ? 'inactive' : 'pending')}">
                                                    ${r.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="empty-cell">Không có dữ liệu gần đây</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Đăng ký tập thử gần đây</h3>
                        <a class="view-all-link" href="${pageContext.request.contextPath}/admin/trials">Xem tất cả</a>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>SĐT</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentTrials}">
                                    <c:forEach var="t" items="${recentTrials}">
                                        <tr>
                                            <td>${t.fullname}</td>
                                            <td>${t.phone}</td>
                                            <td>
                                                <span class="status-badge ${t.status eq 'Đã liên hệ' ? 'contacted' : 'pending'}">
                                                    ${t.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="empty-cell">Không có dữ liệu gần đây</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="dashboard-box">
                    <div class="dashboard-box-header">
                        <h3>Thanh toán gần đây</h3>
                        <a class="view-all-link" href="${pageContext.request.contextPath}/admin/payments">Xem tất cả</a>
                    </div>

                    <div class="table-responsive">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Số tiền</th>
                                <th>Phương thức</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentPayments}">
                                    <c:forEach var="p" items="${recentPayments}">
                                        <tr>
                                            <td>
                                                <fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                                                VNĐ
                                            </td>
                                            <td>${p.paymentMethod}</td>
                                            <td>
                                                <span class="status-badge ${p.status eq 'SUCCESS' or p.status eq 'Đã thanh toán' ? 'active' :
                                                                             (p.status eq 'FAILED' or p.status eq 'Từ chối' or p.status eq 'Đã hủy' ? 'inactive' : 'pending')}">
                                                    ${p.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="empty-cell">Không có dữ liệu gần đây</td>
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
        <c:forEach var="label" items="${monthlyRevenueLabels}" varStatus="loop">
            '${label}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const revenueData = [
        <c:forEach var="value" items="${monthlyRevenueValues}" varStatus="loop">
            ${value}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const paymentStatusLabels = [
        <c:forEach var="label" items="${paymentStatusLabels}" varStatus="loop">
            '${label}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const paymentStatusData = [
        <c:forEach var="value" items="${paymentStatusValues}" varStatus="loop">
            ${value}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const revenueBarColors = [
        '#9f1239',
        '#b30000',
        '#d9480f',
        '#f97316',
        '#be123c',
        '#dc2626',
        '#fb7185',
        '#7f1d1d',
        '#b91c1c',
        '#ea580c',
        '#c2410c',
        '#881337'
    ];

    const paymentPieColors = [
        '#b30000',
        '#f97316',
        '#9f1239',
        '#7f1d1d',
        '#fb7185'
    ];

    const revenueCtx = document.getElementById('revenueChart');
    if (revenueCtx) {
        new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenueData,
                    borderRadius: 12,
                    maxBarThickness: 42,
                    backgroundColor: revenueData.map(function (_, index) {
                        return revenueBarColors[index % revenueBarColors.length];
                    }),
                    hoverBackgroundColor: revenueData.map(function (_, index) {
                        return revenueBarColors[index % revenueBarColors.length];
                    })
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return ' ' + new Intl.NumberFormat('vi-VN').format(context.raw) + ' VNĐ';
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return new Intl.NumberFormat('vi-VN').format(value);
                            }
                        }
                    }
                }
            }
        });
    }

    const paymentCtx = document.getElementById('paymentStatusChart');
    if (paymentCtx) {
        new Chart(paymentCtx, {
            type: 'doughnut',
            data: {
                labels: paymentStatusLabels,
                datasets: [{
                    data: paymentStatusData,
                    backgroundColor: paymentStatusData.map(function (_, index) {
                        return paymentPieColors[index % paymentPieColors.length];
                    }),
                    borderColor: '#ffffff',
                    borderWidth: 3,
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '64%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 14,
                            boxHeight: 14,
                            padding: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return ' ' + context.label + ': ' + context.raw;
                            }
                        }
                    }
                }
            }
        });
    }
</script>
</body>
</html>