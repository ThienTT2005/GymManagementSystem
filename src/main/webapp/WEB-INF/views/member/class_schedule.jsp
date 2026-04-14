<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch học chi tiết | Gym Member</title>
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

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <h3 class="fw-bold mb-3">
                                <i class="bi bi-grid me-2 text-primary"></i>
                                ${gymClass.className}
                            </h3>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <p class="mb-1">
                                        <i class="bi bi-tag me-2 text-muted"></i>
                                        <span class="fw-semibold">Dịch vụ:</span>
                                        ${gymClass.service.serviceName}
                                    </p>
                                    <p class="mb-1">
                                        <i class="bi bi-person me-2 text-muted"></i>
                                        <span class="fw-semibold">Huấn luyện viên:</span>
                                        ${gymClass.trainer.staff.fullName}
                                    </p>
                                    <p class="mb-0">
                                        <i class="bi bi-award me-2 text-muted"></i>
                                        <span class="fw-semibold">Chuyên môn:</span>
                                        ${gymClass.trainer.specialty}
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1">
                                        <i class="bi bi-people me-2 text-muted"></i>
                                        <span class="fw-semibold">Sĩ số:</span>
                                        <span class="${gymClass.currentMember >= gymClass.maxMember
                                                       ? 'text-danger' : 'text-success'} fw-semibold">
                                            ${gymClass.currentMember}/${gymClass.maxMember}
                                        </span>
                                    </p>
                                    <p class="mb-0">
                                        <i class="bi bi-circle-fill me-2
                                            ${gymClass.status == '1' ? 'text-success' : 'text-secondary'}"
                                           style="font-size:8px;vertical-align:middle;"></i>
                                        <span class="fw-semibold">Trạng thái:</span>
                                        ${gymClass.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                                    </p>
                                </div>
                            </div>
                            <c:if test="${not empty gymClass.description}">
                                <hr>
                                <p class="text-muted mb-0">
                                    <i class="bi bi-info-circle me-2"></i>${gymClass.description}
                                </p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>


            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 pt-3">
                    <h5 class="mb-0">
                        <i class="bi bi-calendar-week me-2"></i>Lịch học hàng tuần
                    </h5>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty schedules}">
                            <p class="text-center text-muted py-4">
                                Chưa có lịch học nào được thiết lập.
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Thứ</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="sch" items="${schedules}" varStatus="st">
                                        <tr>
                                            <td>${st.count}</td>
                                            <td>
                                                    <span class="badge bg-primary">
                                                            ${sch.dayOfWeek}
                                                    </span>
                                            </td>
                                            <td>
                                                <i class="bi bi-clock me-1 text-muted"></i>
                                                    ${sch.startTime}
                                            </td>
                                            <td>
                                                <i class="bi bi-clock-fill me-1 text-muted"></i>
                                                    ${sch.endTime}
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

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/member/schedules"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại
                </a>
            </div>

        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>