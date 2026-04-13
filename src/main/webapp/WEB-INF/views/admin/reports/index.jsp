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
</head>

<body>
<div class="app-shell">

    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">

        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">

            <div class="page-header">
                <div>
                    <h1>Báo cáo & thống kê</h1>
                </div>
            </div>

            <c:choose>

                <c:when test="${reportAvailable}">

                    <div class="stats-grid report-stats-grid">

                        <div class="stat-card stat-card-variant-1">
                            <div class="stat-title">
                                <i class="fa-solid fa-sack-dollar"></i>
                                <span>Doanh thu</span>
                            </div>
                            <div class="stat-value stat-value-money">
                                <fmt:formatNumber value="${totalRevenue}" groupingUsed="true"/> VNĐ
                            </div>
                        </div>

                        <div class="stat-card stat-card-variant-2">
                            <div class="stat-title">
                                <i class="fa-solid fa-users"></i>
                                <span>Hội viên</span>
                            </div>
                            <div class="stat-value">${totalMembers}</div>
                        </div>

                        <div class="stat-card stat-card-variant-3">
                            <div class="stat-title">
                                <i class="fa-solid fa-credit-card"></i>
                                <span>Thanh toán</span>
                            </div>
                            <div class="stat-value">${totalPayments}</div>
                        </div>

                        <div class="stat-card stat-card-variant-4">
                            <div class="stat-title">
                                <i class="fa-solid fa-stopwatch"></i>
                                <span>Tập thử</span>
                            </div>
                            <div class="stat-value">${totalTrials}</div>
                        </div>

                        <div class="stat-card stat-card-variant-5">
                            <div class="stat-title">
                                <i class="fa-solid fa-headset"></i>
                                <span>Tư vấn</span>
                            </div>
                            <div class="stat-value">${totalContacts}</div>
                        </div>

                        <div class="stat-card stat-card-variant-6">
                            <div class="stat-title">
                                <i class="fa-solid fa-hourglass-half"></i>
                                <span>Thanh toán chờ</span>
                            </div>
                            <div class="stat-value">${pendingPayments}</div>
                        </div>

                        <div class="stat-card stat-card-variant-7">
                            <div class="stat-title">
                                <i class="fa-solid fa-layer-group"></i>
                                <span>Bảng tháng</span>
                            </div>
                            <div class="stat-value">${empty revenueRows ? 0 : revenueRows.size()}</div>
                        </div>

                        <div class="stat-card stat-card-variant-8">
                            <div class="stat-title">
                                <i class="fa-solid fa-ranking-star"></i>
                                <span>Top hội viên</span>
                            </div>
                            <div class="stat-value">${empty loyalMemberRows ? 0 : loyalMemberRows.size()}</div>
                        </div>

                    </div>

                    <div class="dashboard-grid">

                        <div class="page-card">
                            <div class="table-toolbar">
                                <div class="table-toolbar-left">
                                    <h3>Doanh thu theo tháng</h3>
                                </div>

                                <div class="table-actions">
                                    <a class="btn-sm ${monthLimit == 0 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=0&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Tất cả
                                    </a>
                                    <a class="btn-sm ${monthLimit == 5 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=5&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Top 5
                                    </a>
                                    <a class="btn-sm ${monthLimit == 10 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=10&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Top 10
                                    </a>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="dashboard-table admin-table">
                                    <thead>
                                    <tr>
                                        <th>Tháng</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty revenueRows}">
                                            <c:forEach var="row" items="${revenueRows}">
                                                <tr>
                                                    <td>${row.month}</td>
                                                    <td><fmt:formatNumber value="${row.revenue}" groupingUsed="true"/> VNĐ</td>
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

                        <div class="page-card">
                            <div class="table-toolbar">
                                <div class="table-toolbar-left">
                                    <h3>Doanh thu theo gói tập</h3>
                                </div>

                                <div class="table-actions">
                                    <a class="btn-sm ${packageLimit == 0 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=0&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Tất cả
                                    </a>
                                    <a class="btn-sm ${packageLimit == 5 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=5&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Top 5
                                    </a>
                                    <a class="btn-sm ${packageLimit == 10 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=10&serviceLimit=${serviceLimit}&memberLimit=${memberLimit}">
                                        Top 10
                                    </a>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="dashboard-table admin-table">
                                    <thead>
                                    <tr>
                                        <th>Gói tập</th>
                                        <th>Số giao dịch</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty packageRevenueRows}">
                                            <c:forEach var="row" items="${packageRevenueRows}">
                                                <tr>
                                                    <td>${row.packageName}</td>
                                                    <td>${row.paymentCount}</td>
                                                    <td><fmt:formatNumber value="${row.revenue}" groupingUsed="true"/> VNĐ</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="empty-cell">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="page-card">
                            <div class="table-toolbar">
                                <div class="table-toolbar-left">
                                    <h3>Doanh thu theo dịch vụ</h3>
                                </div>

                                <div class="table-actions">
                                    <a class="btn-sm ${serviceLimit == 0 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=0&memberLimit=${memberLimit}">
                                        Tất cả
                                    </a>
                                    <a class="btn-sm ${serviceLimit == 5 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=5&memberLimit=${memberLimit}">
                                        Top 5
                                    </a>
                                    <a class="btn-sm ${serviceLimit == 10 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=10&memberLimit=${memberLimit}">
                                        Top 10
                                    </a>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="dashboard-table admin-table">
                                    <thead>
                                    <tr>
                                        <th>Dịch vụ</th>
                                        <th>Số giao dịch</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty serviceRevenueRows}">
                                            <c:forEach var="row" items="${serviceRevenueRows}">
                                                <tr>
                                                    <td>${row.serviceName}</td>
                                                    <td>${row.paymentCount}</td>
                                                    <td><fmt:formatNumber value="${row.revenue}" groupingUsed="true"/> VNĐ</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="empty-cell">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="page-card">
                            <div class="table-toolbar">
                                <div class="table-toolbar-left">
                                    <h3>Hội viên thân thiết</h3>
                                </div>

                                <div class="table-actions">
                                    <a class="btn-sm ${memberLimit == 0 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=0">
                                        Tất cả
                                    </a>
                                    <a class="btn-sm ${memberLimit == 5 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=5">
                                        Top 5
                                    </a>
                                    <a class="btn-sm ${memberLimit == 10 ? 'btn-primary' : 'btn-light'}"
                                       href="${pageContext.request.contextPath}/admin/reports?monthLimit=${monthLimit}&packageLimit=${packageLimit}&serviceLimit=${serviceLimit}&memberLimit=10">
                                        Top 10
                                    </a>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="dashboard-table admin-table">
                                    <thead>
                                    <tr>
                                        <th>Hội viên</th>
                                        <th>SĐT</th>
                                        <th>Số giao dịch</th>
                                        <th>Tổng chi</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty loyalMemberRows}">
                                            <c:forEach var="row" items="${loyalMemberRows}">
                                                <tr>
                                                    <td>${row.fullName}</td>
                                                    <td>${empty row.phone ? '-' : row.phone}</td>
                                                    <td>${row.paymentCount}</td>
                                                    <td><fmt:formatNumber value="${row.totalSpent}" groupingUsed="true"/> VNĐ</td>
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

                    </div>

                </c:when>

                <c:otherwise>

                    <div class="page-card report-placeholder-card">
                        <div class="report-placeholder">
                            <i class="fa-solid fa-chart-line"></i>
                            <h3>Chưa có dữ liệu báo cáo</h3>
                            <p>Hệ thống chưa có đủ dữ liệu để hiển thị báo cáo</p>
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                               class="btn-primary">
                                <i class="fa-solid fa-arrow-left"></i>
                                <span>Về dashboard</span>
                            </a>
                        </div>
                    </div>

                </c:otherwise>

            </c:choose>

        </main>

    </div>

</div>
</body>
</html>