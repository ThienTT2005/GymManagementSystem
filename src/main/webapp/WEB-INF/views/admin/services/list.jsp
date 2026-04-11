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
                    <h1>Quản lý dịch vụ</h1>
                </div>

                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/services/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm dịch vụ</span>
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
                      action="${pageContext.request.contextPath}/admin/services"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tên dịch vụ">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" ${status == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${status == 0 ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light" href="${pageContext.request.contextPath}/admin/services">
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
                            <th>Ảnh</th>
                            <th>Tên dịch vụ</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty servicePage.content}">
                                <c:forEach var="item" items="${servicePage.content}" varStatus="loop">
                                    <tr>
                                        <td>${servicePage.number * servicePage.size + loop.index + 1}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.image}">
                                                    <img class="table-avatar js-image-preview"
                                                         src="${pageContext.request.contextPath}/uploads/${item.image}"
                                                         data-preview-label="${item.serviceName}"
                                                         alt="${item.serviceName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="table-avatar"
                                                         src="${pageContext.request.contextPath}/assets/images/default-service.png"
                                                         alt="Dịch vụ">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td><strong>${item.serviceName}</strong></td>

                                        <td><fmt:formatNumber value="${item.price}" type="number"/> đ</td>

                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">
                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/services/edit/${item.serviceId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/services/toggle-status/${item.serviceId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Xác nhận thay đổi trạng thái dịch vụ?');">
                                                    <button type="submit"
                                                            class="btn-sm ${item.status == 1 ? 'btn-toggle-off' : 'btn-toggle-on'}"
                                                            title="${item.status == 1 ? 'Ngừng hoạt động' : 'Kích hoạt'}">
                                                        <i class="fa-solid ${item.status == 1 ? 'fa-toggle-on' : 'fa-toggle-off'}"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có dịch vụ phù hợp</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${servicePage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${servicePage.totalPages - 1}" var="p">
                            <a class="${p + 1 == servicePage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/services?keyword=${keyword}&status=${status}&page=${p + 1}&size=${servicePage.size}">
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