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
    <div class="page-box members-page-box">
        <div class="page-header">
    <div class="page-title">Quản lý hội viên</div>
</div>

        <form method="get" action="${pageContext.request.contextPath}/admin/members" class="toolbar toolbar-members-one-row">
            <div class="toolbar-members-group">
                <div class="search-box members-search-box">
                    <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text"
                            name="keyword"
                            placeholder="Tìm theo tên hội viên hoặc gói tập"
                            value="${param.keyword}">
                </div>

                <select name="status" class="filter-select members-filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Đang hoạt động" ${param.status == 'Đang hoạt động' ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="Tạm dừng" ${param.status == 'Tạm dừng' ? 'selected' : ''}>Tạm dừng</option>
                    <option value="Hết hạn" ${param.status == 'Hết hạn' ? 'selected' : ''}>Hết hạn</option>
                </select>
            </div>
            <div class="toolbar-members-actions">
                    <button type="submit" class="btn-filter">
                        <i class="fa-solid fa-filter"></i> Lọc
                    </button>

                    <a class="btn-add" href="${pageContext.request.contextPath}/admin/members/create">
                        <i class="fa-solid fa-plus"></i> Thêm hội viên
                    </a>
            </div>
        </form>

        <div class="table-box">
            <table class="admin-table members-table">
                <thead>
                <tr>
                    <th>Hội viên</th>
                    <th>Gói tập</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${memberships}">
                    <tr>
                        <td class="text-strong">${item.memberName}</td>
                        <td>${item.packageName}</td>
                        <td class="small-date">${item.startDate}</td>
                        <td class="small-date">${item.endDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'Đang hoạt động'}">
                                    <span class="badge badge-success">${item.status}</span>
                                </c:when>
                                <c:when test="${item.status == 'Tạm dừng'}">
                                    <span class="badge badge-warning">${item.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="table-actions">
                                <a class="btn-edit"
                                   href="${pageContext.request.contextPath}/admin/members/edit/${item.membershipId}">
                                    <i class="fa-regular fa-pen-to-square"></i> Sửa
                                </a>

                                <a class="btn-status-toggle ${item.status == 'Đang hoạt động' ? 'btn-lock' : 'btn-unlock'}"
                                   href="${pageContext.request.contextPath}/admin/members/toggle-status/${item.membershipId}"
                                   onclick="return confirm('Bạn có chắc muốn thay đổi trạng thái hội viên này?')">
                                    <i class="fa-solid ${item.status == 'Đang hoạt động' ? 'fa-pause' : 'fa-play'}"></i>
                                    <c:choose>
                                        <c:when test="${item.status == 'Đang hoạt động'}">Tạm dừng</c:when>
                                        <c:otherwise>Kích hoạt</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty memberships}">
                    <tr>
                        <td colspan="6" class="empty-text">Chưa có dữ liệu hội viên</td>
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
                           href="${pageContext.request.contextPath}/admin/members?page=${currentPage - 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-left"></i></span>
                    </c:otherwise>
                </c:choose>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="page-item ${i == currentPage ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/members?page=${i}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                        ${i + 1}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages - 1}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/members?page=${currentPage + 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
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