<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <div class="page-box payments-page-box">
        <div class="page-header">
            <div class="page-title">Thanh toán</div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/admin/payments" class="toolbar toolbar-members-one-row">
            <div class="toolbar-members-group">
                <div class="search-box members-search-box">
                    <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text"
                           name="keyword"
                           placeholder="Tìm theo hội viên, gói tập, phương thức..."
                           value="${param.keyword}">
                </div>

                <select name="status" class="filter-select members-filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Chờ duyệt" ${param.status == 'Chờ duyệt' ? 'selected' : ''}>Chờ duyệt</option>
                    <option value="Đã duyệt" ${param.status == 'Đã duyệt' ? 'selected' : ''}>Đã duyệt</option>
                    <option value="Từ chối" ${param.status == 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                </select>
            </div>

            <div class="toolbar-members-actions">
                <button type="submit" class="btn-filter">
                    <i class="fa-solid fa-filter"></i> Lọc
                </button>
            </div>
        </form>

        <div class="table-box">
            <table class="admin-table payments-table">
                <thead>
                <tr>
                    <th>Hội viên</th>
                    <th>Gói tập</th>
                    <th>Số tiền</th>
                    <th>Phương thức</th>
                    <th>Ngày thanh toán</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${paymentList}">
                    <tr>
                        <td class="text-strong">${item.memberName}</td>
                        <td>${item.packageName}</td>
                        <td class="money">
                            <fmt:formatNumber value="${item.amount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                        </td>
                        <td>${item.paymentMethod}</td>
                        <td class="small-date">${item.paymentDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'Đã duyệt'}">
                                    <span class="badge badge-success">${item.status}</span>
                                </c:when>
                                <c:when test="${item.status == 'Từ chối'}">
                                    <span class="badge badge-danger">${item.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="table-actions payments-actions">
                                <c:if test="${item.status == 'Chờ duyệt'}">
                                    <a class="btn-action-green"
                                       href="${pageContext.request.contextPath}/admin/payments/approve/${item.paymentId}"
                                       onclick="return confirm('Xác nhận duyệt thanh toán này?')">
                                        <i class="fa-solid fa-check"></i> Duyệt
                                    </a>

                                    <a class="btn-action-red"
                                       href="${pageContext.request.contextPath}/admin/payments/reject/${item.paymentId}"
                                       onclick="return confirm('Xác nhận từ chối thanh toán này?')">
                                        <i class="fa-solid fa-xmark"></i> Từ chối
                                    </a>
                                </c:if>

                                <c:if test="${item.status != 'Chờ duyệt'}">
                                    <a class="btn-edit"
                                       href="${pageContext.request.contextPath}/admin/payments/edit/${item.paymentId}">
                                        <i class="fa-regular fa-pen-to-square"></i> Sửa
                                    </a>

                                    <a class="btn-delete"
                                       href="${pageContext.request.contextPath}/admin/payments/delete/${item.paymentId}"
                                       onclick="return confirm('Bạn có chắc muốn xóa thanh toán này?')">
                                        <i class="fa-regular fa-trash-can"></i> Xóa
                                    </a>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty paymentList}">
                    <tr>
                        <td colspan="7" class="empty-text">Chưa có dữ liệu thanh toán</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-box">
                <c:choose>
                    <c:when test="${currentPage > 0}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/payments?page=${currentPage - 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-left"></i></span>
                    </c:otherwise>
                </c:choose>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="page-item ${i == currentPage ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/payments?page=${i}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                        ${i + 1}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages - 1}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/payments?page=${currentPage + 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                            <i class="fa-solid fa-angle-right"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-right"></i></span>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>