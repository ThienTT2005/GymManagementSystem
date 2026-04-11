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

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>Quản lý huấn luyện viên</h1>
                </div>

                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/trainers/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm</span>
                </a>
            </div>

            <!-- FLASH -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <!-- FILTER -->
            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/admin/trainers"
                      class="filter-form">

                    <div class="filter-group filter-group-grow">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tên / chuyên môn">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Trạng thái</option>
                            <option value="1" <c:if test="${status == 1}">selected</c:if>>Hoạt động</option>
                            <option value="0" <c:if test="${status == 0}">selected</c:if>>Ngừng</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>

                        <a class="btn-light"
                           href="${pageContext.request.contextPath}/admin/trainers">
                            <i class="fa-solid fa-rotate-right"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- TABLE -->
            <div class="page-card">
                <div class="table-responsive">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Ảnh</th>
                            <th>Nhân viên</th>
                            <th>SĐT</th>
                            <th>Chức vụ</th>
                            <th>Chuyên môn</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>

                            <c:when test="${not empty trainerPage.content}">
                                <c:forEach var="item" items="${trainerPage.content}" varStatus="loop">
                                    <tr>

                                        <td>${trainerPage.number * trainerPage.size + loop.index + 1}</td>

                                        <!-- AVATAR -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.photo}">
                                                    <img class="table-avatar"
                                                         src="${pageContext.request.contextPath}/uploads/${item.photo}"
                                                         alt="${item.staffName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="table-avatar"
                                                         src="${pageContext.request.contextPath}/assets/images/default-avatar.png">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- NAME -->
                                        <td>
                                            <strong>${empty item.staffName ? '---' : item.staffName}</strong>
                                        </td>

                                        <!-- PHONE -->
                                        <td>${empty item.staffPhone ? '---' : item.staffPhone}</td>

                                        <!-- POSITION -->
                                        <td>${empty item.staffPosition ? '---' : item.staffPosition}</td>

                                        <!-- SPECIALTY -->
                                        <td>${empty item.specialty ? '---' : item.specialty}</td>

                                        <!-- STATUS -->
                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng'}
                                            </span>
                                        </td>

                                        <!-- ACTION -->
                                        <td>
                                            <div class="table-actions">

                                                <a class="btn-sm btn-light"
                                                   href="${pageContext.request.contextPath}/admin/trainers/detail/${item.trainerId}"
                                                   title="Xem">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>

                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/trainers/edit/${item.trainerId}"
                                                   title="Sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/trainers/toggle-status/${item.trainerId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Đổi trạng thái?');">

                                                    <button type="submit"
                                                            class="btn-sm ${item.status == 1 ? 'btn-toggle-off' : 'btn-toggle-on'}"
                                                            title="${item.status == 1 ? 'Ngừng' : 'Bật'}">
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
                                        Không có huấn luyện viên
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- PAGINATION -->
                <c:if test="${trainerPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${trainerPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == trainerPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/trainers?keyword=${keyword}&status=${status}&page=${p + 1}&size=${trainerPage.size}">
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