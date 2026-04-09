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
                    <h1>Quản lý lịch học</h1>
                    <p>Lịch học của các lớp trong hệ thống</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/schedules/create">
                    <i class="fa fa-plus"></i> Thêm lịch học
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/schedules" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên lớp">
                    </div>

                    <div class="filter-group">
                        <select name="dayOfWeek">
                            <option value="">Tất cả thứ</option>
                            <option value="MONDAY" <c:if test="${dayOfWeek == 'MONDAY'}">selected</c:if>>MONDAY</option>
                            <option value="TUESDAY" <c:if test="${dayOfWeek == 'TUESDAY'}">selected</c:if>>TUESDAY</option>
                            <option value="WEDNESDAY" <c:if test="${dayOfWeek == 'WEDNESDAY'}">selected</c:if>>WEDNESDAY</option>
                            <option value="THURSDAY" <c:if test="${dayOfWeek == 'THURSDAY'}">selected</c:if>>THURSDAY</option>
                            <option value="FRIDAY" <c:if test="${dayOfWeek == 'FRIDAY'}">selected</c:if>>FRIDAY</option>
                            <option value="SATURDAY" <c:if test="${dayOfWeek == 'SATURDAY'}">selected</c:if>>SATURDAY</option>
                            <option value="SUNDAY" <c:if test="${dayOfWeek == 'SUNDAY'}">selected</c:if>>SUNDAY</option>
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
                            <th>Lớp học</th>
                            <th>Thứ</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty schedulePage.content}">
                                <c:forEach var="item" items="${schedulePage.content}">
                                    <tr>
                                        <td>${item.scheduleId}</td>
                                        <td>${item.gymClass.className}</td>
                                        <td>${item.dayOfWeek}</td>
                                        <td>${item.startTime}</td>
                                        <td>${item.endTime}</td>
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
                                               href="${pageContext.request.contextPath}/admin/schedules/edit/${item.scheduleId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/schedules/delete/${item.scheduleId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn ngừng lịch học này?');">
                                                <button type="submit" class="btn-sm btn-delete">Ngừng</button>
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

                <c:if test="${schedulePage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${schedulePage.totalPages - 1}" var="p">
                            <a class="${p + 1 == schedulePage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/schedules?keyword=${keyword}&dayOfWeek=${dayOfWeek}&page=${p + 1}&size=${schedulePage.size}">
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