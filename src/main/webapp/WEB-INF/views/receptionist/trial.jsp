<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tập thử</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-topbar">
                <h2 class="page-title">Đăng ký tập thử</h2>
            </div>

            <div class="list-card">
                <div class="list-toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/receptionist/trial" class="search-form">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên, số điện thoại, email">
                        </div>

                        <select name="status" class="filter-select">
                            <option value="">Tất cả</option>
                            <option value="PENDING" ${status eq 'PENDING' ? 'selected' : ''}>Chưa xử lý</option>
                            <option value="PROCESSED" ${status eq 'PROCESSED' ? 'selected' : ''}>Đã xử lý</option>
                        </select>

                        <button type="submit" class="filter-btn">Lọc</button>
                    </form>
                </div>

                <table class="member-table">
                    <thead>
                    <tr>
                        <th>Tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Ngày mong muốn</th>
                        <th>Ghi chú</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty trials}">
                            <c:forEach var="t" items="${trials}">
                                <tr>
                                    <td>${t.fullname}</td>
                                    <td>${t.phone}</td>
                                    <td>${t.email}</td>
                                    <td>${t.preferredDate}</td>
                                    <td>${t.note}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status eq 'PENDING'}">
                                                <span class="status-badge pending">Chưa xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge success">Đã xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/receptionist/trial/toggle">
                                            <input type="hidden" name="trialId" value="${t.trialId}">
                                            <c:choose>
                                                <c:when test="${t.status eq 'PENDING'}">
                                                    <button type="submit" class="mini-action-btn warning-btn">Chưa xử lý</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="mini-action-btn success-btn">Đã xử lý</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="empty-row">Chưa có dữ liệu đăng ký tập thử</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <div class="pagination-box">
                    <c:if test="${page > 1}">
                        <a class="page-btn" href="?keyword=${keyword}&status=${status}&page=${page - 1}">&laquo;</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a class="page-btn ${i == page ? 'active' : ''}" href="?keyword=${keyword}&status=${status}&page=${i}">${i}</a>
                    </c:forEach>

                    <c:if test="${page < totalPages}">
                        <a class="page-btn" href="?keyword=${keyword}&status=${status}&page=${page + 1}">&raquo;</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>