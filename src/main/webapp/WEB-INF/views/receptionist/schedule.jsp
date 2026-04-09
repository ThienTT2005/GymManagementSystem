<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch học</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-topbar">
                <h2 class="page-title">Lịch học</h2>
            </div>

            <div class="list-card">
                <div class="list-toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/receptionist/schedule" class="search-form">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm lớp, giáo viên, thứ hoặc phòng">
                        </div>
                        <button type="submit" class="filter-btn">Tìm</button>
                    </form>
                </div>

                <div class="table-wrap">
                    <table class="member-table">
                        <thead>
                        <tr>
                            <th>ID lớp</th>
                            <th>Lớp</th>
                            <th>Giáo viên</th>
                            <th>Thứ</th>
                            <th>Giờ</th>
                            <th>Phòng</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <c:forEach var="s" items="${schedules}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${s.gymClass != null}">
                                                    ${s.gymClass.classId}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${s.gymClass != null}">
                                                    ${s.gymClass.className}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${s.gymClass != null and not empty s.gymClass.trainerName}">
                                                    ${s.gymClass.trainerName}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${s.dayOfWeek}</td>
                                        <td>${s.startTime} - ${s.endTime}</td>
                                        <td>${s.status}</td>

                                        <td>
                                            <c:if test="${s.gymClass != null}">
                                                <a href="${pageContext.request.contextPath}/receptionist/class-members?classId=${s.gymClass.classId}"
                                                   class="action-btn view-btn">
                                                    <i class="fa-regular fa-eye"></i>
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-row">Chưa có dữ liệu lịch học</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-box">
                    <c:if test="${page > 1}">
                        <a class="page-btn" href="?keyword=${keyword}&page=${page - 1}">&laquo;</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a class="page-btn ${i == page ? 'active' : ''}" href="?keyword=${keyword}&page=${i}">${i}</a>
                    </c:forEach>

                    <c:if test="${page < totalPages}">
                        <a class="page-btn" href="?keyword=${keyword}&page=${page + 1}">&raquo;</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>