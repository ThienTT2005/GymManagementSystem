<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.gym.GymManagementSystem.model.User u = (com.gym.GymManagementSystem.model.User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Gym Member</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/member_navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/views/common/member_sidebar.jsp"/>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <h2 class="mb-4">Xin chào, <strong><%= u.getFullName() %></strong>!</h2>

            <%-- CARD: Gói tập hiện tại --%>
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-primary-subtle me-3">
                                    <i class="bi bi-award text-primary fs-4"></i>
                                </div>
                                <h6 class="card-title mb-0">Gói tập hiện tại</h6>
                            </div>
                            <c:choose>
                                <c:when test="${not empty membership}">
                                    <p class="fw-bold fs-5 mb-1"><p>${membership.pkg.packageName}</p></p>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test='${membership.status == "active"}'>bg-success</c:when>
                                            <c:when test='${membership.status == "pending"}'>bg-warning text-dark</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                            ${membership.status}
                                    </span>
                                    <p class="text-muted small mt-2 mb-0">
                                        HSD: <fmt:formatDate value="${membership.endDate}" pattern="dd/MM/yyyy" type="date"/>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-2">Bạn chưa có gói tập</p>
                                    <a href="${pageContext.request.contextPath}/member/packages" class="btn btn-sm btn-primary">Đăng ký ngay</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-success-subtle me-3">
                                    <i class="bi bi-calendar-check text-success fs-4"></i>
                                </div>
                                <h6 class="card-title mb-0">Lớp đang theo học</h6>
                            </div>
                            <p class="fw-bold fs-3 mb-0">
                                ${fn:length(myClasses)}
                            </p>
                            <a href="${pageContext.request.contextPath}/member/schedules" class="btn btn-sm btn-outline-success mt-2">Xem lịch</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-warning-subtle me-3">
                                    <i class="bi bi-person-circle text-warning fs-4"></i>
                                </div>
                                <h6 class="card-title mb-0">Tài khoản</h6>
                            </div>
                            <p class="mb-1"><%= u.getEmail() %></p>
                            <p class="text-muted small mb-2"><%= u.getPhone() != null ? u.getPhone() : "Chưa cập nhật SĐT" %></p>
                            <a href="${pageContext.request.contextPath}/member/profile" class="btn btn-sm btn-outline-warning">Cập nhật</a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Lịch học đang tham gia --%>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 pt-3">
                    <h5 class="mb-0"><i class="bi bi-list-check me-2"></i>Lịch học của tôi</h5>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty myClasses}">
                            <p class="text-muted text-center py-4">Bạn chưa đăng ký lớp nào.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Lớp học</th><th>HLV</th><th>Chi nhánh</th>
                                        <th>Thứ</th><th>Giờ</th><th>Trạng thái</th><th></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="cr" items="${myClasses}">
                                        <tr>
                                            <td>${cr.schedule.service.serviceName}</td>
                                            <td>${cr.schedule.trainer.trainerName}</td>
                                            <td>${cr.schedule.club.clubName}</td>
                                            <td>${cr.schedule.dayOfWeek}</td>
                                            <td>${cr.schedule.startTime} – ${cr.schedule.endTime}</td>
                                            <td>
                                                <span class="badge ${cr.status == 'active' ? 'bg-success' : 'bg-secondary'}">
                                                        ${cr.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${cr.status == 'active'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/member/cancel-class" class="d-inline">
                                                        <input type="hidden" name="registrationId" value="${cr.registrationId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('Huỷ đăng ký lớp này?')">Huỷ</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
