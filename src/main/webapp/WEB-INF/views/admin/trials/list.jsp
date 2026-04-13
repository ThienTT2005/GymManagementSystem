<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                    <h1>Quản lý tập thử</h1>
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
                      action="${pageContext.request.contextPath}/admin/trials"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tên / SĐT / Email">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Trạng thái</option>
                            <option value="PENDING" ${status=='PENDING'?'selected':''}>Chưa xử lý</option>
                            <option value="CONTACTED" ${status=='CONTACTED'?'selected':''}>Đã liên hệ</option>
                            <option value="DONE" ${status=='DONE'?'selected':''}>Đã tập</option>
                            <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>Hủy</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <input type="date" name="preferredDate" value="${preferredDate}">
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm</span>
                    </button>

                    <a class="btn-light"
                       href="${pageContext.request.contextPath}/admin/trials">
                        <i class="fa-solid fa-rotate-right"></i>
                        <span>Reset</span>
                    </a>

                </form>

            </div>

            <div class="page-card">

                <div class="table-responsive">

                    <table class="dashboard-table admin-table">

                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Ngày tập</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th>Ngày tạo</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty trials}">
                                <c:forEach var="item" items="${trials}" varStatus="loop">

                                    <tr>

                                        <td>
                                            ${trialPage.number * trialPage.size + loop.index + 1}
                                        </td>

                                        <td><strong>${item.fullname}</strong></td>

                                        <td>${item.phone}</td>

                                        <td>${not empty item.email ? item.email : '-'}</td>

                                        <td>${not empty item.preferredDate ? item.preferredDate : '-'}</td>

                                        <td>
                                            <span class="status-badge
                                                ${item.status == 'PENDING' ? 'pending' :
                                                  item.status == 'CONTACTED' ? 'processing' :
                                                  item.status == 'DONE' ? 'active' : 'inactive'}">

                                                <c:choose>
                                                    <c:when test="${item.status == 'PENDING'}">Chưa xử lý</c:when>
                                                    <c:when test="${item.status == 'CONTACTED'}">Đã liên hệ</c:when>
                                                    <c:when test="${item.status == 'DONE'}">Đã tập</c:when>
                                                    <c:otherwise>Hủy</c:otherwise>
                                                </c:choose>

                                            </span>
                                        </td>

                                        <td>${not empty item.note ? item.note : '-'}</td>

                                        <td>${item.createdAt}</td>

                                    </tr>

                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-cell">
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

                <c:if test="${not empty trialPage and trialPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="1" end="${trialPage.totalPages}" var="p">
                            <a class="${p == trialPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/trials?keyword=${keyword}&status=${status}&preferredDate=${preferredDate}&page=${p}&size=${trialPage.size}">
                                ${p}
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