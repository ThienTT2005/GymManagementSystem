<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch tập | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-calendar3 me-2"></i>Lịch tập</h2>

            <%-- Thông báo --%>
            <c:if test="${param.success == '1'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>Đăng ký lớp thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.success == 'cancelled'}">
                <div class="alert alert-info alert-dismissible fade show">
                    <i class="bi bi-info-circle me-2"></i>Đã huỷ đăng ký lớp.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'already_registered'}">
                <div class="alert alert-warning">Bạn đã đăng ký lớp này rồi.</div>
            </c:if>
            <c:if test="${param.error == 'class_full'}">
                <div class="alert alert-danger">Lớp đã đầy, vui lòng chọn lớp khác.</div>
            </c:if>

            <%-- Bộ lọc chi nhánh --%>
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body py-3">
                    <form method="get" action="${pageContext.request.contextPath}/member/schedules" class="row g-2 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label mb-1 fw-semibold">Lọc theo chi nhánh</label>
                            <select name="clubId" class="form-select">
                                <option value="">-- Tất cả chi nhánh --</option>
                                <c:forEach var="club" items="${clubs}">
                                    <option value="${club.clubId}"
                                        ${selectedClubId == club.clubId ? 'selected' : ''}>
                                            ${club.clubName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-funnel me-1"></i>Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/member/schedules" class="btn btn-outline-secondary ms-1">
                                Xem tất cả
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <%-- Bảng lịch tập --%>
            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty schedules}">
                            <p class="text-center text-muted py-5">Không có lịch tập nào.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-dark">
                                    <tr>
                                        <th>Lớp học</th>
                                        <th>Huấn luyện viên</th>
                                        <th>Chi nhánh</th>
                                        <th>Thứ</th>
                                        <th>Giờ học</th>
                                        <th>Sĩ số</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="sch" items="${schedules}">
                                        <tr>
                                            <td>
                                                <strong>${sch.schedule.service.serviceName}</strong>
                                            </td>
                                            <td>${sch.schedule.trainer.trainerName}</td>
                                            <td>${sch.schedule.club.clubName}</td>
                                            <td>${sch.schedule.dayOfWeek}</td>
                                            <td>
                                                <i class="bi bi-clock me-1 text-muted"></i>
                                                    ${sch.schedule.startTime} – ${sch.schedule.endTime}
                                            </td>
                                            <td>
                                                <span class="${sch.registeredCount >= sch.schedule.maxMember ? 'text-danger' : 'text-success'} fw-semibold">
                                                    ${sch.registeredCount}/${sch.schedule.maxMember}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sch.registeredCount >= sch.schedule.maxMember}">
                                                        <span class="badge bg-danger">Đầy lớp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="post" action="${pageContext.request.contextPath}/member/register-class" class="d-inline">
                                                            <input type="hidden" name="scheduleId" value="${sch.schedule.scheduleId}">
                                                            <button type="submit" class="btn btn-sm btn-success">
                                                                <i class="bi bi-plus-circle me-1"></i>Đăng ký
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
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
