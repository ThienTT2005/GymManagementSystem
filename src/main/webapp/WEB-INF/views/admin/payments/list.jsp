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
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Quản lý thanh toán</h1>
                    <p>Danh sách thanh toán membership và đăng ký lớp</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/payments/create">
                    <i class="fa fa-plus"></i> Thêm thanh toán
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/payments" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên hội viên">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" <c:if test="${status == 'PENDING'}">selected</c:if>>PENDING</option>
                            <option value="PAID" <c:if test="${status == 'PAID'}">selected</c:if>>PAID</option>
                            <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>REJECTED</option>
                            <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-secondary">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                </form>

                <div class="table-wrap">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hội viên</th>
                            <th>Loại</th>
                            <th>Số tiền</th>
                            <th>Phương thức</th>
                            <th>Ngày thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Minh chứng</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty paymentPage.content}">
                                <c:forEach var="item" items="${paymentPage.content}">
                                    <tr>
                                        <td>${item.paymentId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.membership != null}">
                                                    ${item.membership.member.fullname}
                                                </c:when>
                                                <c:when test="${item.classRegistration != null}">
                                                    ${item.classRegistration.member.fullname}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.membership != null}">Membership</c:when>
                                                <c:when test="${item.classRegistration != null}">Class Registration</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatNumber value="${item.amount}" type="number" maxFractionDigits="0"/> đ</td>
                                        <td>${item.paymentMethod}</td>
                                        <td>${item.paymentDate}</td>
                                        <td>
                                            <span class="
                                                ${item.status == 'PAID' ? 'badge-active' : ''}
                                                ${item.status == 'PENDING' ? 'badge-warning' : ''}
                                                ${item.status == 'REJECTED' || item.status == 'CANCELLED' ? 'badge-inactive' : ''}">
                                                ${item.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.proofImage}">
                                                    <a href="${pageContext.request.contextPath}/uploads/${item.proofImage}" target="_blank">Xem ảnh</a>
                                                </c:when>
                                                <c:otherwise>Không có</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/admin/payments/edit/${item.paymentId}">
                                                Sửa
                                            </a>

                                            <c:if test="${item.status == 'PENDING'}">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/payments/approve/${item.paymentId}"
                                                      style="display:inline-block">
                                                    <button type="submit" class="btn-sm btn-approve">Duyệt</button>
                                                </form>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/payments/reject/${item.paymentId}"
                                                      style="display:inline-block">
                                                    <button type="submit" class="btn-sm btn-delete">Từ chối</button>
                                                </form>
                                            </c:if>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/payments/delete/${item.paymentId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa mềm thanh toán này?');">
                                                <button type="submit" class="btn-sm btn-delete">Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="empty-cell">Không có dữ liệu</td>
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
                               href="${pageContext.request.contextPath}/admin/payments?keyword=${keyword}&status=${status}&page=${p + 1}&size=${paymentPage.size}">
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