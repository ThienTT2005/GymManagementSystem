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
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Lớp đang phụ trách</h1>
                    <p>Danh sách các lớp được phân công cho bạn</p>
                </div>
            </div>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/trainer/classes" class="filter-form">
                    <div class="filter-group filter-group-grow">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên lớp hoặc dịch vụ">
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <span>Tìm kiếm</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/trainer/classes" class="btn-light">
                            <i class="fa-solid fa-rotate-right"></i>
                            <span>Đặt lại</span>
                        </a>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Tên lớp</th>
                            <th>Dịch vụ</th>
                            <th>Số học viên</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty trainerClasses}">
                                <c:forEach var="c" items="${trainerClasses}">
                                    <tr>
                                        <td>${c.className}</td>
                                        <td>${c.service != null ? c.service.serviceName : '-'}</td>
                                        <td>${c.currentMember} / ${c.maxMember}</td>
                                        <td>
                                            <span class="status-badge ${c.status == 1 ? 'active' : 'inactive'}">
                                                ${c.status == 1 ? 'Hoạt động' : 'Ngừng'}
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/trainer/class-detail?id=${c.classId}">
                                                <i class="fa-solid fa-eye"></i>
                                                <span>Xem lớp</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="empty-cell">Không có lớp phụ trách</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>