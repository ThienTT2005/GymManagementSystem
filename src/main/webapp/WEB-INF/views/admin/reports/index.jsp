<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="page-title" style="margin-bottom: 20px;">Báo cáo thống kê</div>

    <!-- 4 thẻ thống kê -->
    <div class="stat-grid" style="grid-template-columns: repeat(4, 1fr);">
        <div class="stat-card bg-1">
            <h3>Tổng giao dịch</h3>
            <p>${totalPayments}</p>
        </div>

        <div class="stat-card bg-2">
            <h3>Chờ duyệt</h3>
            <p>${pendingPayments}</p>
        </div>

        <div class="stat-card bg-4">
            <h3>Tổng doanh thu</h3>
            <p>
                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
            </p>
        </div>

        <div class="stat-card bg-5">
            <h3>Đăng ký tập thử</h3>
            <p>${trialCount}</p>
        </div>
    </div>

    <!-- Hàng dưới -->
    <div class="dashboard-row">
        <!-- Biểu đồ -->
        <div class="dashboard-col" style="flex: 2;">
            <div class="page-box">
                <div class="section-title">Doanh thu theo tháng</div>
                <div style="height: 350px;">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Top package -->
        <div class="dashboard-col" style="flex: 1; min-width: 320px;">
            <div class="page-box">
                <div class="section-title">Top gói tập phổ biến</div>

                <div class="table-box">
                    <table>
                        <thead>
                        <tr>
                            <th>Gói tập</th>
                            <th>Số lượt</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${topPackages}">
                            <tr>
                                <td>${item[0]}</td>
                                <td>
                                    <span class="badge badge-info">${item[1]}</span>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty topPackages}">
                            <tr>
                                <td colspan="2" class="empty-text">Chưa có dữ liệu gói tập</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

<script>
    const labels = [
        <c:forEach var="label" items="${revenueLabels}" varStatus="loop">
        "${label}"<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const values = [
        <c:forEach var="value" items="${revenueValues}" varStatus="loop">
        ${value}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const ctx = document.getElementById('revenueChart');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu',
                data: values,
                backgroundColor: '#b91c1c',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
</script>

</body>
</html>