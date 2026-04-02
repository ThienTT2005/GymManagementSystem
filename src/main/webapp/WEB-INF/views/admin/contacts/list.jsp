<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
    <div class="page-box contacts-page-box">
        <div class="page-header">
            <div class="page-title">Liên hệ</div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/admin/contacts" class="toolbar toolbar-members-one-row">
            <div class="toolbar-members-group">
                <div class="search-box members-search-box">
                    <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text"
                           name="keyword"
                           placeholder="Tìm theo tên, email, số điện thoại, nội dung..."
                           value="${param.keyword}">
                </div>

                <select name="status" class="filter-select members-filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Chưa xử lý" ${param.status == 'Chưa xử lý' ? 'selected' : ''}>Chưa xử lý</option>
                    <option value="Đã phản hồi" ${param.status == 'Đã phản hồi' ? 'selected' : ''}>Đã phản hồi</option>
                </select>
            </div>

            <div class="toolbar-members-actions">
                <button type="submit" class="btn-filter">
                    <i class="fa-solid fa-filter"></i> Lọc
                </button>

                <a class="btn-add" href="${pageContext.request.contextPath}/admin/contacts/create">
                    <i class="fa-solid fa-plus"></i> Thêm liên hệ
                </a>
            </div>
        </form>

        <div class="table-box">
            <table class="admin-table contacts-table">
                <thead>
                <tr>
                    <th>Họ tên</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th>Nội dung</th>
                    <th>Ngày liên hệ</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${contactList}">
                    <tr>
                        <td class="text-strong">${item.fullName}</td>
                        <td>${item.phone}</td>
                        <td>${item.email}</td>
                        <td class="contact-message-cell">
                            <c:choose>
                                <c:when test="${fn:length(item.message) > 80}">
                                    ${fn:substring(item.message, 0, 80)}...
                                </c:when>
                                <c:otherwise>
                                    ${item.message}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small-date">${item.contactDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'Đã phản hồi'}">
                                    <span class="badge badge-success">${item.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="table-actions">
                                <a class="btn-edit"
                                   href="${pageContext.request.contextPath}/admin/contacts/edit/${item.contactId}">
                                    <i class="fa-regular fa-pen-to-square"></i> Sửa
                                </a>

                                <a class="btn-status-toggle ${item.status == 'Đã phản hồi' ? 'btn-lock' : 'btn-unlock'}"
                                   href="${pageContext.request.contextPath}/admin/contacts/toggle-status/${item.contactId}"
                                   onclick="return confirm('Bạn có chắc muốn thay đổi trạng thái liên hệ này?')">
                                    <i class="fa-solid ${item.status == 'Đã phản hồi' ? 'fa-rotate-left' : 'fa-check'}"></i>
                                    <c:choose>
                                        <c:when test="${item.status == 'Đã phản hồi'}">Đặt lại</c:when>
                                        <c:otherwise>Đã phản hồi</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty contactList}">
                    <tr>
                        <td colspan="7" class="empty-text">Chưa có dữ liệu liên hệ</td>
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
                           href="${pageContext.request.contextPath}/admin/contacts?page=${currentPage - 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-left"></i></span>
                    </c:otherwise>
                </c:choose>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="page-item ${i == currentPage ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/contacts?page=${i}&size=${size}&keyword=${param.keyword}&status=${param.status}">
                        ${i + 1}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages - 1}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/contacts?page=${currentPage + 1}&size=${size}&keyword=${param.keyword}&status=${param.status}">
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