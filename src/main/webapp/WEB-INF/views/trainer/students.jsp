<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css">
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
                    <h1>Danh sách học viên</h1>
                    <p>Học viên theo từng lớp bạn phụ trách</p>
                </div>
            </div>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/trainer/class-members" class="filter-form">
                    <div class="filter-group">
                        <select name="classId">
                            <option value="">-- Chọn lớp --</option>
                            <c:forEach var="c" items="${trainerClasses}">
                                <option value="${c.classId}" <c:if test="${selectedClassId == c.classId}">selected</c:if>>
                                    ${c.className}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên / SĐT / email">
                    </div>

                    <button type="submit" class="btn-secondary">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                </form>

                <div class="table-wrap">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>Số điện thoại</th>
                            <th>Email</th>
                            <th>Lớp</th>
                            <th>Ngày bắt đầu</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty classMembers}">
                                <c:forEach var="item" items="${classMembers}">
                                    <tr>
                                        <td>${item.member.fullname}</td>
                                        <td>${item.member.phone}</td>
                                        <td>${item.member.email}</td>
                                        <td>${item.gymClass.className}</td>
                                        <td>${item.startDate}</td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/trainer/student-detail?id=${item.member.memberId}&classId=${item.gymClass.classId}">
                                                Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có học viên</td>
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