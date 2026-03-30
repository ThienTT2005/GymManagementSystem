<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="page-box dashboard-page">
        <div class="page-title dashboard-title">Trang chủ quản trị</div>

        <div class="stat-grid">
            <div class="stat-card bg-1">
                <div class="stat-card-head">
                    <span class="stat-icon"><i class="fa-solid fa-users"></i></span>
                    <span class="stat-label">Tổng hội viên</span>
                </div>
                <p>${totalMembers}</p>
            </div>

            <div class="stat-card bg-2">
                <div class="stat-card-head">
                    <span class="stat-icon"><i class="fa-solid fa-circle-check"></i></span>
                    <span class="stat-label">Gói tập đang hoạt động</span>
                </div>
                <p>${activePackages}</p>
            </div>

            <div class="stat-card bg-3">
                <div class="stat-card-head">
                    <span class="stat-icon"><i class="fa-solid fa-file-invoice-dollar"></i></span>
                    <span class="stat-label">Thanh toán chờ duyệt</span>
                </div>
                <p>${pendingPayments}</p>
            </div>

            <div class="stat-card bg-4">
                <div class="stat-card-head">
                    <span class="stat-icon"><i class="fa-solid fa-layer-group"></i></span>
                    <span class="stat-label">Dịch vụ</span>
                </div>
                <p>${totalServices}</p>
            </div>

            <div class="stat-card bg-5">
                <div class="stat-card-head">
                    <span class="stat-icon"><i class="fa-solid fa-building"></i></span>
                    <span class="stat-label">Chi nhánh</span>
                </div>
                <p>${totalBranches}</p>
            </div>
        </div>

        <div class="dashboard-row">
            <div class="dashboard-col">
                <div class="page-box dashboard-panel">
                    <div class="panel-header">
                        <div class="section-title">Danh sách đăng ký gói đang chờ duyệt</div>
                    </div>

                    <div class="table-box">
                        <table>
                            <thead>
                            <tr>
                                <th>Hội viên</th>
                                <th>Gói tập</th>
                                <th>Phương thức</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${pendingPaymentList}">
                                <tr>
                                    <td>${item.memberName}</td>
                                    <td>${item.packageName}</td>
                                    <td>${item.paymentMethod}</td>
                                    <td>
                                        <span class="badge badge-warning">${item.status}</span>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty pendingPaymentList}">
                                <tr>
                                    <td colspan="4" class="empty-text">
                                        Không có thanh toán chờ duyệt
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="panel-footer">
                        <a href="${pageContext.request.contextPath}/admin/payments" class="view-all-link">
                            Xem tất cả <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <div class="dashboard-col">
                <div class="page-box dashboard-panel">
                    <div class="panel-header">
                        <div class="section-title">Danh sách đăng ký tập thử chưa xử lý</div>
                    </div>

                    <div class="table-box">
                        <table>
                            <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>SĐT</th>
                                <th>Chi nhánh</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${trialList}">
                                <tr>
                                    <td>${item.fullName}</td>
                                    <td>${item.phone}</td>
                                    <td>${item.branchName}</td>
                                    <td>
                                        <span class="badge badge-danger">${item.status}</span>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty trialList}">
                                <tr>
                                    <td colspan="4" class="empty-text">
                                        Không có đăng ký tập thử chưa xử lý
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="panel-footer">
                        <a href="${pageContext.request.contextPath}/admin/trials" class="view-all-link">
                            Xem tất cả <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-row">
            <div class="dashboard-col">
    <div class="page-box dashboard-panel">
        <div class="panel-header">
            <div class="section-title">Doanh thu theo tháng</div>
        </div>

        <div class="chart-placeholder">
            <div class="chart-bars">
                <c:forEach var="item" items="${monthlyRevenue}">
                    <div class="bar-group">
                        <div class="bar bar-red" style="height: ${item.heightCurrentYear}px;"></div>
                        <div class="bar bar-orange" style="height: ${item.heightPreviousYear}px;"></div>
                        <span>Tháng ${item.month}</span>
                    </div>
                </c:forEach>

                <c:if test="${empty monthlyRevenue}">
                    <div class="empty-text" style="width: 100%; padding-top: 80px;">
                        Chưa có dữ liệu doanh thu
                    </div>
                </c:if>
            </div>

            <div class="chart-legend">
                <span><i class="legend-box legend-red"></i> Năm ${currentYear}</span>
                <span><i class="legend-box legend-orange"></i> Năm ${previousYear}</span>
            </div>
        </div>
    </div>
</div>

            <div class="dashboard-col">
                <div class="page-box dashboard-panel">
                    <div class="panel-header">
                        <div class="section-title">Danh sách lớp học hôm nay</div>
                    </div>

                    <div class="table-box">
                        <table>
                            <thead>
                            <tr>
                                <th>Lớp học</th>
                                <th>Giờ</th>
                                <th>Huấn luyện viên</th>
                                <th>Chi nhánh</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${todayClasses}">
                                <tr>
                                    <td>${item.className}</td>
                                    <td>${item.scheduleTime}</td>
                                    <td>${item.trainerName}</td>
                                    <td>${item.branchName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'Đang mở'}">
                                                <span class="badge badge-success">${item.status}</span>
                                            </c:when>
                                            <c:when test="${item.status == 'Tạm dừng'}">
                                                <span class="badge badge-warning">${item.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">${item.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty todayClasses}">
                                <tr>
                                    <td colspan="5" class="empty-text">
                                        Hôm nay chưa có lớp học nào
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="panel-footer">
                        <a href="${pageContext.request.contextPath}/admin/schedules" class="view-all-link">
                            Xem tất cả <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>