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
                    <h1>Quản lý đăng ký gói tập</h1>
                    <p>Danh sách đăng ký gói tập của hội viên</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/memberships/create">
                    <i class="fa fa-plus"></i> Thêm đăng ký
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/memberships" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên hội viên">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" <c:if test="${status == 'PENDING'}">selected</c:if>>PENDING</option>
                            <option value="ACTIVE" <c:if test="${status == 'ACTIVE'}">selected</c:if>>ACTIVE</option>
                            <option value="EXPIRED" <c:if test="${status == 'EXPIRED'}">selected</c:if>>EXPIRED</option>
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
                            <th>Gói tập</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty membershipPage.content}">
                                <c:forEach var="item" items="${membershipPage.content}">
                                    <tr>
                                        <td>${item.membershipId}</td>
                                        <td>${item.member != null ? item.member.fullname : ''}</td>
                                        <td>${item.gymPackage != null ? item.gymPackage.packageName : ''}</td>
                                        <td>${item.startDate}</td>
                                        <td>${item.endDate}</td>
                                        <td>
                                            <span class="${item.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">
                                                ${item.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/admin/memberships/edit/${item.membershipId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/memberships/delete/${item.membershipId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn hủy đăng ký này?');">
                                                <button type="submit" class="btn-sm btn-delete">Hủy</button>
                                            </form>
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

                <c:if test="${membershipPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${membershipPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == membershipPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/memberships?keyword=${keyword}&status=${status}&page=${p + 1}&size=${membershipPage.size}">
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