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
                    <h1>Quản lý huấn luyện viên</h1>
                    <p>Hồ sơ chuyên môn, kinh nghiệm và ảnh trainer</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/trainers/create">
                    <i class="fa fa-plus"></i> Thêm huấn luyện viên
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/trainers" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm chuyên môn / tên nhân viên">
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
                            <th>Ảnh hồ sơ</th>
                            <th>Nhân viên</th>
                            <th>Phone</th>
                            <th>Chức vụ</th>
                            <th>Chuyên môn</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty trainerPage.content}">
                                <c:forEach var="item" items="${trainerPage.content}">
                                    <tr>
                                        <td>${item.trainerId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.photo}">
                                                    <img class="thumb-image"
                                                         src="${pageContext.request.contextPath}/uploads/${item.photo}"
                                                         alt="${item.staffName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="no-image">No image</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${item.staffName}</td>
                                        <td>${item.staffPhone}</td>
                                        <td>${item.staffPosition}</td>
                                        <td>${item.specialty}</td>
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
                                               href="${pageContext.request.contextPath}/admin/trainers/edit/${item.trainerId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/trainers/delete/${item.trainerId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn ngừng huấn luyện viên này?');">
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