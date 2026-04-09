<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Thanh toán</h1>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/receptionist/payments/create">Thêm thanh toán</a>
            </div>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/receptionist/payments" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm hội viên">
                    </div>
                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" <c:if test="${status == 'PENDING'}">selected</c:if>>PENDING</option>
                            <option value="PAID" <c:if test="${status == 'PAID'}">selected</c:if>>PAID</option>
                            <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>REJECTED</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-secondary">Tìm kiếm</button>
                </form>

                <table class="dashboard-table">
                    <thead>
                    <tr>
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
                    <c:forEach var="item" items="${paymentPage.content}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${item.membership != null}">
                                        ${item.membership.member.fullname}
                                    </c:when>
                                    <c:when test="${item.classRegistration != null}">
                                        ${item.classRegistration.member.fullname}
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.membership != null}">Membership</c:when>
                                    <c:when test="${item.classRegistration != null}">Class Registration</c:when>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${item.amount}" type="number" maxFractionDigits="0"/> đ</td>
                            <td>${item.paymentMethod}</td>
                            <td>${item.paymentDate}</td>
                            <td>${item.status}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.proofImage}">
                                        <a href="${pageContext.request.contextPath}/uploads/${item.proofImage}" target="_blank">Xem ảnh</a>
                                    </c:when>
                                    <c:otherwise>Không có</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${item.status == 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/receptionist/payments/approve/${item.paymentId}" style="display:inline-block">
                                        <button type="submit" class="btn-sm btn-approve">Duyệt</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/receptionist/payments/reject/${item.paymentId}" style="display:inline-block">
                                        <button type="submit" class="btn-sm btn-delete">Từ chối</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
</body>
</html>