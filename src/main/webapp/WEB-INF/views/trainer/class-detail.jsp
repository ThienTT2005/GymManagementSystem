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

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>Chi tiết lớp</h1>
                </div>

                <a href="${pageContext.request.contextPath}/trainer/classes"
                   class="btn-light">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
            </div>

            <div class="page-card">

                <!-- CLASS INFO -->
                <div class="profile-section-title">
                    <h3>${gymClass.className}</h3>
                </div>

                <div class="profile-detail-grid">

                    <div class="profile-detail-item">
                        <label>Dịch vụ</label>
                        <p>${gymClass.service != null ? gymClass.service.serviceName : '---'}</p>
                    </div>

                    <div class="profile-detail-item">
                        <label>Huấn luyện viên</label>
                        <p>${empty gymClass.trainerName ? '---' : gymClass.trainerName}</p>
                    </div>

                    <div class="profile-detail-item">
                        <label>Học viên</label>
                        <p>${memberCount}/${gymClass.maxMember}</p>
                    </div>

                    <div class="profile-detail-item">
                        <label>Trạng thái</label>
                        <p>
                            <span class="status-badge ${gymClass.status == 1 ? 'active' : 'inactive'}">
                                ${gymClass.status == 1 ? 'Hoạt động' : 'Ngừng'}
                            </span>
                        </p>
                    </div>

                </div>

                <!-- DESCRIPTION -->
                <c:if test="${not empty gymClass.description}">
                    <div class="detail-section">
                        <h3>Mô tả</h3>
                        <p>${gymClass.description}</p>
                    </div>
                </c:if>

                <!-- SCHEDULE -->
                <div class="detail-section">
                    <h3>Lịch học</h3>

                    <div class="table-responsive">
                        <table class="dashboard-table admin-table">
                            <thead>
                            <tr>
                                <th>Thứ</th>
                                <th>Bắt đầu</th>
                                <th>Kết thúc</th>
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
                                        <td colspan="3" class="empty-cell">
                                            Chưa có lịch học
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- MEMBERS -->
                <div class="detail-section">
                    <h3>Học viên</h3>

                    <div class="table-responsive">
                        <table class="dashboard-table admin-table">
                            <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>SĐT</th>
                                <th>Email</th>
                                <th>Bắt đầu</th>
                                <th></th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty classMembers}">
                                    <c:forEach var="m" items="${classMembers}">
                                        <tr>

                                            <td>${empty m.member.fullname ? '---' : m.member.fullname}</td>

                                            <td>${empty m.member.phone ? '---' : m.member.phone}</td>

                                            <td>${empty m.member.email ? '---' : m.member.email}</td>

                                            <td>${empty m.startDate ? '---' : m.startDate}</td>

                                            <td>
                                                <a class="btn-sm btn-light"
                                                   href="${pageContext.request.contextPath}/trainer/student-detail?id=${m.member.memberId}&classId=${gymClass.classId}"
                                                   title="Xem">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="empty-cell">
                                            Chưa có học viên
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

        </main>
    </div>
</div>
</body>
</html>