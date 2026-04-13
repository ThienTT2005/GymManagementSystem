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
                    <h1>Quản lý thanh toán</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/admin/payments"
                      class="filter-form">

                    <div class="filter-group filter-group-grow">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tên hội viên / ID">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Trạng thái</option>
                            <option value="PENDING" ${status=='PENDING'?'selected':''}>Chờ duyệt</option>
                            <option value="PAID" ${status=='PAID'?'selected':''}>Đã thanh toán</option>
                            <option value="REJECTED" ${status=='REJECTED'?'selected':''}>Từ chối</option>
                            <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>Đã hủy</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="paymentMethod">
                            <option value="">Phương thức</option>
                            <option value="CASH" ${paymentMethod=='CASH'?'selected':''}>Tiền mặt</option>
                            <option value="BANK_TRANSFER" ${paymentMethod=='BANK_TRANSFER'?'selected':''}>Chuyển khoản</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <input type="date" name="fromDate" value="${fromDate}">
                    </div>

                    <div class="filter-group">
                        <input type="date" name="toDate" value="${toDate}">
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm</span>
                    </button>
                </form>
            </div>

            <div class="page-card">
                <div class="table-responsive">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hội viên</th>
                            <th>Loại</th>
                            <th>Số tiền</th>
                            <th>Phương thức</th>
                            <th>Ngày</th>
                            <th>Ảnh</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty payments}">
                                <c:forEach var="p" items="${payments}" varStatus="loop">
                                    <tr>
                                        <td>${paymentPage.number * paymentPage.size + loop.index + 1}</td>

                                        <td><strong>${p.displayMemberName}</strong></td>

                                        <td>${p.displayType}</td>

                                        <td>
                                            <fmt:formatNumber value="${p.amount}" type="number"/> VNĐ
                                        </td>

                                        <td>${p.paymentMethod}</td>
                                        <td>${p.paymentDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.proofImage}">
                                                    <img src="${pageContext.request.contextPath}/uploads/${p.proofImage}"
                                                         class="thumb-image payment-proof js-image-preview"
                                                         data-preview-label="Minh chứng thanh toán"
                                                         alt="Minh chứng thanh toán">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="cell-muted">---</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <span class="status-badge ${p.status == 'PAID' ? 'active' : p.status == 'PENDING' ? 'pending' : p.status == 'REJECTED' ? 'rejected' : 'inactive'}">
                                                <c:choose>
                                                    <c:when test="${p.status == 'PAID'}">Đã thanh toán</c:when>
                                                    <c:when test="${p.status == 'PENDING'}">Chờ duyệt</c:when>
                                                    <c:when test="${p.status == 'REJECTED'}">Từ chối</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">
                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/payments/edit/${p.paymentId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <c:if test="${p.status == 'PENDING'}">
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/admin/payments/approve/${p.paymentId}"
                                                          class="inline-form"
                                                          onsubmit="return confirm('Xác nhận duyệt thanh toán này?');">
                                                        <button class="btn-sm btn-approve" type="submit" title="Duyệt">
                                                            <i class="fa-solid fa-check"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="empty-cell">Không có dữ liệu thanh toán phù hợp</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${paymentPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${paymentPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == paymentPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/payments?keyword=${keyword}&status=${status}&paymentMethod=${paymentMethod}&fromDate=${fromDate}&toDate=${toDate}&page=${p + 1}&size=${paymentPage.size}">
                                ${p + 1}
                            </a>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
</body>
</html>