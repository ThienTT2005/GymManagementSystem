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
    <div class="page-box users-page-box">
        <div class="page-header users-page-header">
            <div class="page-title">Quản lý người dùng</div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/admin/users" class="toolbar toolbar-users-one-row">
            <div class="toolbar-users-group">
                <div class="search-box users-search-box">
                    <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text"
                           name="keyword"
                           placeholder="Tìm theo tên đăng nhập hoặc email"
                           value="${param.keyword}">
                </div>

                <select name="role" class="filter-select users-filter-select">
                    <option value="">Tất cả vai trò</option>
                    <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                    <option value="MEMBER" ${param.role == 'MEMBER' ? 'selected' : ''}>MEMBER</option>
                    <option value="STAFF" ${param.role == 'STAFF' ? 'selected' : ''}>STAFF</option>
                </select>

                <select name="status" class="filter-select users-filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Hoạt động" ${param.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                    <option value="Khóa" ${param.status == 'Khóa' ? 'selected' : ''}>Khóa</option>
                </select>
            </div>

            <div class="toolbar-users-actions">
                <button type="submit" class="btn-filter">
                    <i class="fa-solid fa-filter"></i> Lọc
                </button>

                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn-add">
                    <i class="fa-solid fa-plus"></i> Thêm người dùng
                </a>
            </div>
        </form>

        <div class="table-box">
            <table class="admin-table users-table">
                <thead>
                <tr>
                    <th>Họ tên</th>
                    <th>Tên đăng nhập</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${users}">
                    <tr>
                        <td>
                            <div class="avatar-cell">
                                <c:choose>
                                    <c:when test="${not empty item.avatar}">
                                        <img src="${pageContext.request.contextPath}${item.avatar}"
                                             alt="avatar"
                                             class="avatar-mini-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                                             alt="avatar"
                                             class="avatar-mini-img">
                                    </c:otherwise>
                                </c:choose>
                                <span>${item.fullName}</span>
                            </div>
                        </td>

                        <td class="text-strong">${item.username}</td>
                        <td>${item.email}</td>
                        <td>${item.phone}</td>

                        <td>
                            <c:choose>
                                <c:when test="${item.role == 'ADMIN'}">
                                    <span class="badge badge-danger">ADMIN</span>
                                </c:when>
                                <c:when test="${item.role == 'STAFF'}">
                                    <span class="badge badge-warning">STAFF</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-info">${item.role}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'Hoạt động'}">
                                    <span class="badge badge-success">${item.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-gray">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <div class="table-actions user-actions">
                                <a class="btn-edit"
                                   href="${pageContext.request.contextPath}/admin/users/edit/${item.userId}">
                                    <i class="fa-regular fa-pen-to-square"></i> Chỉnh sửa
                                </a>

                                <a class="btn-status-toggle ${item.status == 'Hoạt động' ? 'btn-lock' : 'btn-unlock'}"
                                    href="${pageContext.request.contextPath}/admin/users/toggle-status/${item.userId}"
                                    onclick="return confirm('Bạn có chắc muốn thay đổi trạng thái tài khoản này?')">
                                        <i class="fa-solid ${item.status == 'Hoạt động' ? 'fa-lock' : 'fa-lock-open'}"></i>
                                        <c:choose>
                                            <c:when test="${item.status == 'Hoạt động'}">Khóa</c:when>
                                            <c:otherwise>Mở khóa</c:otherwise>
                                        </c:choose>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty users}">
                    <tr>
                        <td colspan="7" class="empty-text">Chưa có dữ liệu người dùng</td>
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
                            href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&size=${size}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-left"></i></span>
                    </c:otherwise>
                </c:choose>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="page-item ${i == currentPage ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/admin/users?page=${i}&size=${size}&keyword=${param.keyword}&role=${param.role}&status=${param.status}"> ${i + 1}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages - 1}">
                        <a class="page-item"
                            href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&size=${size}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">
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