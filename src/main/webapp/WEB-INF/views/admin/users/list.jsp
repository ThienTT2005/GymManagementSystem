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
                    <h1>Quản lý tài khoản</h1>
                </div>

                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/users/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm tài khoản</span>
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/admin/users"
                      class="filter-form">

                    <div class="filter-group filter-group-grow">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo username">
                    </div>

                    <div class="filter-group">
                        <select name="roleId">
                            <option value="">Tất cả quyền</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}" ${roleId == role.roleId ? 'selected' : ''}>
                                    ${role.roleName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" ${status == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${status == 0 ? 'selected' : ''}>Đã khóa</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fa-solid fa-rotate-right"></i>
                            <span>Reset</span>
                        </a>
                    </div>
                </form>
            </div>

            <div class="page-card">
                <div class="table-responsive">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Username</th>
                            <th>Quyền</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty users}">
                                <c:forEach var="item" items="${users}" varStatus="loop">
                                    <tr>
                                        <td>${userPage.number * userPage.size + loop.index + 1}</td>

                                        <td><strong>${item.username}</strong></td>

                                        <td>${empty item.roleName ? '---' : item.roleName}</td>

                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Đã khóa'}
                                            </span>
                                        </td>

                                        <td>${empty item.createdAtFormatted ? '---' : item.createdAtFormatted}</td>

                                        <td>
                                            <div class="table-actions">
                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/users/edit/${item.userId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/users/toggle-status/${item.userId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Xác nhận thay đổi trạng thái tài khoản này?');">
                                                    <button type="submit"
                                                            class="btn-sm ${item.status == 1 ? 'btn-delete' : 'btn-primary'}"
                                                            title="${item.status == 1 ? 'Khóa' : 'Mở khóa'}">
                                                        <i class="fa-solid ${item.status == 1 ? 'fa-lock' : 'fa-unlock'}"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có tài khoản phù hợp</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${userPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${userPage.totalPages - 1}" var="p">
                            <a class="${p == userPage.number ? 'active' : ''}"
                               href="?page=${p + 1}&size=${userPage.size}&keyword=${keyword}&roleId=${roleId}&status=${status}">
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