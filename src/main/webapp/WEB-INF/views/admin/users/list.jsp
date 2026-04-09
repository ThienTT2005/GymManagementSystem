<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                    <h1>Quản lý tài khoản</h1>
                    <p>Danh sách tài khoản đăng nhập hệ thống</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/users/create">
                    <i class="fa fa-plus"></i> Thêm tài khoản
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm username">
                    </div>

                    <div class="filter-group">
                        <select name="roleName">
                            <option value="">Tất cả quyền</option>
                            <option value="ADMIN" <c:if test="${roleName == 'ADMIN'}">selected</c:if>>ADMIN</option>
                            <option value="RECEPTIONIST" <c:if test="${roleName == 'RECEPTIONIST'}">selected</c:if>>RECEPTIONIST</option>
                            <option value="TRAINER" <c:if test="${roleName == 'TRAINER'}">selected</c:if>>TRAINER</option>
                            <option value="MEMBER" <c:if test="${roleName == 'MEMBER'}">selected</c:if>>MEMBER</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" <c:if test="${status == 1}">selected</c:if>>Hoạt động</option>
                            <option value="0" <c:if test="${status == 0}">selected</c:if>>Ngừng</option>
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
                            <th>Avatar</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty userPage.content}">
                                <c:forEach var="item" items="${userPage.content}">
                                    <tr>
                                        <td>${item.userId}</td>
                                        <td>
                                            <img class="table-avatar"
                                                 src="${pageContext.request.contextPath}/uploads/${empty item.avatar ? 'default-avatar.png' : item.avatar}"
                                                 alt="${item.username}">
                                        </td>
                                        <td>${item.username}</td>
                                        <td>${item.roleName}</td>
                                        <td>
                                            <span class="${item.status == 1 ? 'badge-active' : 'badge-inactive'}">
                                                <c:choose>
                                                    <c:when test="${item.status == 1}">Hoạt động</c:when>
                                                    <c:otherwise>Ngừng</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/admin/users/edit/${item.userId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/users/delete/${item.userId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn ngừng kích hoạt tài khoản này?');">
                                                <button type="submit" class="btn-sm btn-delete">Ngừng</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${userPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${userPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == userPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&roleName=${roleName}&status=${status}&page=${p + 1}&size=${userPage.size}">
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