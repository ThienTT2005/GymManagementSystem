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
                    <h1>Chi tiết lớp học</h1>
                </div>
            </div>

            <div class="page-card">
                <h2>${gymClass.className}</h2>

                <div class="detail-grid">
                    <div>
                        <strong>Dịch vụ:</strong>
                        ${gymClass.service != null ? gymClass.service.serviceName : '-'}
                    </div>

                    <div>
                        <strong>Huấn luyện viên:</strong>
                        ${empty gymClass.trainerName ? '-' : gymClass.trainerName}
                    </div>

                    <div>
                        <strong>Số học viên hiện tại:</strong>
                        ${memberCount}
                    </div>

                    <div>
                        <strong>Số lượng tối đa:</strong>
                        ${gymClass.maxMember}
                    </div>

                    <div>
                        <strong>Trạng thái:</strong>
                        <span class="status-badge ${gymClass.status == 1 ? 'active' : 'inactive'}">
                            ${gymClass.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>
                </div>

                <c:if test="${not empty gymClass.description}">
                    <div class="detail-section">
                        <h3>Mô tả lớp học</h3>
                        <p>${gymClass.description}</p>
                    </div>
                </c:if>

                <div class="detail-section">
                    <h3>Lịch học</h3>
                    <div class="table-responsive">
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
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/classes" class="btn-light">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Quay lại</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/classes/edit/${gymClass.classId}" class="btn-primary">
                        <i class="fa-solid fa-pen"></i>
                        <span>Chỉnh sửa</span>
                    </a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>