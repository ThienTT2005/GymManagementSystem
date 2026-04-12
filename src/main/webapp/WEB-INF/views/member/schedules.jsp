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
            <a href="${pageContext.request.contextPath}/member/classes"
               class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i>Đăng ký lớp mới
            </a>

            <%-- Bảng lịch tập --%>
            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty myClasses}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
                                <p class="text-muted">Bạn chưa đăng ký lớp học nào.</p>
                                <a href="${pageContext.request.contextPath}/member/classes"
                                   class="btn btn-primary">Xem danh sách lớp</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-dark">
                                    <tr>
                                        <th>#</th>
                                        <th>Lớp học</th>
                                        <th>Dịch vụ</th>
                                        <th>Huấn luyện viên</th>
                                        <th>Lịch học</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Trạng thái</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="cr" items="${myClasses}" varStatus="st">
                                        <tr>
                                            <td>${st.count}</td>
                                            <td><strong>${cr.classes.className}</strong></td>
                                            <td>${cr.classes.service.serviceName}</td>
                                            <td>${cr.classes.trainer.staff.fullName}</td>
                                            <td>
                                                    <%-- Hiển thị lịch học của lớp --%>
                                                <c:forEach var="sch" items="${cr.classes.schedules}">
                                                        <span class="badge bg-light text-dark border me-1">
                                                            ${sch.dayOfWeek} ${sch.startTime}–${sch.endTime}
                                                        </span>
                                                </c:forEach>
                                            </td>
                                            <td>${cr.startDate}</td>
                                            <td>
                                                <span class="badge
                                                            <c:choose>
                                                                <c:when test='${cr.status == "active"}'>bg-success</c:when>
                                                                <c:when test='${cr.status == "pending"}'>bg-warning text-dark</c:when>
                                                                <c:otherwise>bg-secondary</c:otherwise>
                                                            </c:choose>">
                                                        ${cr.status}
                                                </span>
                                            </td>
                                            <td>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/member/cancel-class"
                                                      class="d-inline"
                                                      onsubmit="return confirm('Huỷ đăng ký lớp này?')">
                                                    <input type="hidden" name="classRegistrationId"
                                                           value="${cr.classRegistrationId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">Huỷ</button>
                                                </form>
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
