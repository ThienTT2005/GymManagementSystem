<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Quản lý hội viên</h1>
                    <p>Tra cứu, thêm và cập nhật thông tin hội viên</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/receptionist/members/create">
                    <i class="fa fa-plus"></i> Thêm hội viên
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/receptionist/members" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm họ tên / SĐT / email">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" <c:if test="${status == 1}">selected</c:if>>Hoạt động</option>
                            <option value="0" <c:if test="${status == 0}">selected</c:if>>Ngừng</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-secondary">Tìm kiếm</button>
                </form>

                <div class="table-wrap">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Giới tính</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty memberPage.content}">
                                <c:forEach var="item" items="${memberPage.content}">
                                    <tr>
                                        <td>${item.memberId}</td>
                                        <td>${item.fullname}</td>
                                        <td>${item.phone}</td>
                                        <td>${item.email}</td>
                                        <td>${item.gender}</td>
                                        <td>
                                            <span class="${item.status == 1 ? 'badge-active' : 'badge-inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng'}
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/receptionist/members/detail/${item.memberId}">
                                                Xem
                                            </a>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/receptionist/members/edit/${item.memberId}">
                                                Sửa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="empty-cell">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${memberPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${memberPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == memberPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/receptionist/members?keyword=${keyword}&status=${status}&page=${p + 1}&size=${memberPage.size}">
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