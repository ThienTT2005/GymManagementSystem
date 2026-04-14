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
                    <h1>Quản lý tư vấn</h1>
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
                      action="${pageContext.request.contextPath}/admin/contacts"
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
                            <option value="NEW" ${status=='NEW'?'selected':''}>Chờ liên hệ</option>
                            <option value="CONTACTED" ${status=='CONTACTED'?'selected':''}>Đã liên hệ</option>
                        </select>
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm</span>
                    </button>

                    <a class="btn-light"
                       href="${pageContext.request.contextPath}/admin/contacts">
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
                            <th>Trạng thái</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty contacts}">
                                <c:forEach var="item" items="${contacts}" varStatus="loop">

                                    <tr>

                                        <td>
                                            ${contactPage.number * contactPage.size + loop.index + 1}
                                        </td>

                                        <td><strong>${item.fullname}</strong></td>

                                        <td>${item.phone}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.email}">
                                                    ${item.email}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <span class="status-badge ${item.status == 'CONTACTED' ? 'contacted' : 'pending'}">
                                                <c:choose>
                                                    <c:when test="${item.status == 'CONTACTED'}">Đã liên hệ</c:when>
                                                    <c:otherwise>Chờ liên hệ</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                    </tr>

                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

                <c:if test="${not empty contactPage and contactPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="1" end="${contactPage.totalPages}" var="p">
                            <a class="${p == contactPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/contacts?keyword=${keyword}&status=${status}&page=${p}&size=${contactPage.size}">
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