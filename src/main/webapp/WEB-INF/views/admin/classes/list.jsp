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
                    <h1>Quản lý lớp học</h1>
                    <p>Lớp học gắn service và trainer, không dùng room</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/classes/create">
                    <i class="fa fa-plus"></i> Thêm lớp học
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/classes" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên lớp">
                    </div>

                    <div class="filter-group">
                        <select name="serviceId">
                            <option value="">Tất cả dịch vụ</option>
                            <c:forEach var="s" items="${services}">
                                <option value="${s.serviceId}" <c:if test="${serviceId == s.serviceId}">selected</c:if>>
                                    ${s.serviceName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="trainerId">
                            <option value="">Tất cả trainer</option>
                            <c:forEach var="t" items="${trainers}">
                                <option value="${t.trainerId}" <c:if test="${trainerId == t.trainerId}">selected</c:if>>
                                    ${t.staffName}
                                </option>
                            </c:forEach>
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
                            <th>Tên lớp</th>
                            <th>Dịch vụ</th>
                            <th>Trainer</th>
                            <th>Hiện tại</th>
                            <th>Tối đa</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty classPage.content}">
                                <c:forEach var="item" items="${classPage.content}">
                                    <tr>
                                        <td>${item.classId}</td>
                                        <td>${item.className}</td>
                                        <td>${item.service != null ? item.service.serviceName : ''}</td>
                                        <td>${item.trainerName}</td>
                                        <td>${item.currentMember}</td>
                                        <td>${item.maxMember}</td>
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
                                               href="${pageContext.request.contextPath}/admin/classes/edit/${item.classId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/classes/delete/${item.classId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn ngừng lớp học này?');">
                                                <button type="submit" class="btn-sm btn-delete">Ngừng</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-cell">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${classPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${classPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == classPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/classes?keyword=${keyword}&serviceId=${serviceId}&trainerId=${trainerId}&status=${status}&page=${p + 1}&size=${classPage.size}">
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