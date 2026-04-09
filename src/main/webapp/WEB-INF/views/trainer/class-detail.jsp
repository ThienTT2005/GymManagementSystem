<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-card">
                <h2>${gymClass.className}</h2>

                <div class="detail-grid">
                    <div><strong>Dịch vụ:</strong> ${gymClass.service != null ? gymClass.service.serviceName : ''}</div>
                    <div><strong>HLV:</strong> ${gymClass.trainerName}</div>
                    <div><strong>Số học viên hiện tại:</strong> ${memberCount}</div>
                    <div><strong>Số lượng tối đa:</strong> ${gymClass.maxMember}</div>
                    <div><strong>Trạng thái:</strong> ${gymClass.status == 1 ? 'Hoạt động' : 'Ngừng'}</div>
                </div>

                <c:if test="${not empty gymClass.description}">
                    <div class="detail-section">
                        <h3>Mô tả lớp học</h3>
                        <p>${gymClass.description}</p>
                    </div>
                </c:if>

                <div class="detail-section">
                    <h3>Lịch học</h3>
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Thứ</th>
                            <th>Giờ bắt đầu</th>
                            <th>Giờ kết thúc</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty schedules}">
                                <c:forEach var="s" items="${schedules}">
                                    <tr>
                                        <td>${s.dayOfWeek}</td>
                                        <td>${s.startTime}</td>
                                        <td>${s.endTime}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="empty-cell">Chưa có lịch học</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="detail-section">
                    <h3>Danh sách học viên</h3>
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>Số điện thoại</th>
                            <th>Email</th>
                            <th>Ngày bắt đầu</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty classMembers}">
                                <c:forEach var="m" items="${classMembers}">
                                    <tr>
                                        <td>${m.member.fullname}</td>
                                        <td>${m.member.phone}</td>
                                        <td>${m.member.email}</td>
                                        <td>${m.startDate}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="empty-cell">Chưa có học viên</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/trainer/class-members?classId=${gymClass.classId}"
                       class="btn-secondary">Quay lại</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>