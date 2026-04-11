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
                    <h1>Quản lý lớp học</h1>
                </div>

                <a class="btn-primary"
                   href="${pageContext.request.contextPath}/admin/classes/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm lớp</span>
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
                      action="${pageContext.request.contextPath}/admin/classes"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm tên lớp">
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
                            <option value="">Tất cả HLV</option>
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
                            <option value="0" <c:if test="${status == 0}">selected</c:if>>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light"
                           href="${pageContext.request.contextPath}/admin/classes">
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
                            <th>Tên lớp</th>
                            <th>Dịch vụ</th>
                            <th>HLV</th>
                            <th>Hiện tại</th>
                            <th>Tối đa</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty classPage.content}">
                                <c:forEach var="item" items="${classPage.content}" varStatus="loop">
                                    <tr>
                                        <td>${classPage.number * classPage.size + loop.index + 1}</td>
                                        <td><strong>${item.className}</strong></td>
                                        <td>${item.service != null ? item.service.serviceName : '---'}</td>
                                        <td>${empty item.trainerName ? '---' : item.trainerName}</td>
                                        <td>${item.currentMember}</td>
                                        <td>${item.maxMember}</td>

                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">
                                                <a class="btn-sm btn-light"
                                                   href="${pageContext.request.contextPath}/admin/classes/detail/${item.classId}"
                                                   title="Xem chi tiết">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>

                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/classes/edit/${item.classId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/classes/toggle-status/${item.classId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Xác nhận thay đổi trạng thái lớp học?');">
                                                    <button class="btn-sm ${item.status == 1 ? 'btn-toggle-off' : 'btn-toggle-on'}"
                                                            type="submit"
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
                                    <td colspan="8" class="empty-cell">Không có lớp học phù hợp</td>
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