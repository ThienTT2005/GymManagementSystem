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
                    <h1>Quản lý lịch học</h1>
                </div>

                <a class="btn-primary"
                   href="${pageContext.request.contextPath}/admin/schedules/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm lịch</span>
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
                      action="${pageContext.request.contextPath}/admin/schedules"
                      class="filter-form">

                    <div class="filter-group">
                        <input type="text" name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tên lớp">
                    </div>

                    <div class="filter-group">
                        <select name="dayOfWeek">
                            <option value="">Tất cả thứ</option>
                            <option value="MONDAY" ${dayOfWeek=='MONDAY'?'selected':''}>MONDAY</option>
                            <option value="TUESDAY" ${dayOfWeek=='TUESDAY'?'selected':''}>TUESDAY</option>
                            <option value="WEDNESDAY" ${dayOfWeek=='WEDNESDAY'?'selected':''}>WEDNESDAY</option>
                            <option value="THURSDAY" ${dayOfWeek=='THURSDAY'?'selected':''}>THURSDAY</option>
                            <option value="FRIDAY" ${dayOfWeek=='FRIDAY'?'selected':''}>FRIDAY</option>
                            <option value="SATURDAY" ${dayOfWeek=='SATURDAY'?'selected':''}>SATURDAY</option>
                            <option value="SUNDAY" ${dayOfWeek=='SUNDAY'?'selected':''}>SUNDAY</option>
                        </select>
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm</span>
                    </button>

                    <a class="btn-light"
                       href="${pageContext.request.contextPath}/admin/schedules">
                        <i class="fa-solid fa-rotate-right"></i>
                        <span>Reset</span>
                    </a>

                </form>

            </div>

            <div class="page-card">

                <div class="table-responsive">

                    <table class="dashboard-table admin-table">

                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Lớp</th>
                            <th>HLV</th>
                            <th>Thứ</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty schedulePage.content}">
                                <c:forEach var="item" items="${schedulePage.content}" varStatus="st">

                                    <tr>
                                        <td>${schedulePage.number * schedulePage.size + st.index + 1}</td>

                                        <td>
                                            ${item.gymClass != null ? item.gymClass.className : '-'}
                                        </td>

                                        <td>
                                            ${item.gymClass != null ? item.gymClass.trainerName : '-'}
                                        </td>

                                        <td>${item.dayOfWeek}</td>
                                        <td>${item.startTime}</td>
                                        <td>${item.endTime}</td>

                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">

                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/schedules/edit/${item.scheduleId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/schedules/toggle-status/${item.scheduleId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Xác nhận thay đổi trạng thái lịch học?');">

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
                                    <td colspan="8" class="empty-cell">
                                        Không có dữ liệu
                                    </td>
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