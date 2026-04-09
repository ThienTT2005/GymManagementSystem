<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách hội viên lớp</title>
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
                <h2 class="page-title">Danh sách hội viên lớp</h2>
                <a href="${pageContext.request.contextPath}/receptionist/schedule" class="secondary-btn">Quay lại</a>
            </div>

            <div class="list-card">
                <div class="table-wrap">
                    <table class="member-table">
                        <thead>
                        <tr>
                            <th>ID hội viên</th>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Dịch vụ</th>
                            <th>Lớp học</th>
                            <th>Ngày đăng ký</th>
                            <th>Ngày bắt đầu</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty classMembers}">
                                <c:forEach var="cm" items="${classMembers}">
                                    <tr>
                                        <td>${cm.member.memberId}</td>
                                        <td>${cm.member.fullname}</td>
                                        <td>${cm.member.phone}</td>
                                        <td>${cm.member.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cm.service != null}">
                                                    ${cm.service.serviceName}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cm.gymClass != null}">
                                                    ${cm.gymClass.className}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${cm.registrationDate}</td>
                                        <td>${cm.startDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cm.status eq 'ACTIVE'}">
                                                    <span class="status-badge active">ACTIVE</span>
                                                </c:when>
                                                <c:when test="${cm.status eq 'REJECTED'}">
                                                    <span class="status-badge cancelled">REJECTED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge pending">${cm.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="empty-row">Chưa có hội viên trong lớp này</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>