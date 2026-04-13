<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
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

            <h2 class="mb-4">Xin chào, <strong>${member.fullname}</strong>!</h2>

            <!-- CARD -->
            <div class="row g-4 mb-4">

                <!-- GÓI TẬP -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">

                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-primary-subtle me-3">
                                    <i class="bi bi-award text-primary fs-4"></i>
                                </div>
                                <h6 class="mb-0">Gói tập hiện tại</h6>
                            </div>

                            <c:choose>
                                <c:when test="${not empty membership}">
                                    <p class="fw-bold fs-5 mb-1">
                                            ${membership.gymPackage.packageName}
                                    </p>

                                    <span class="badge
                                    ${membership.status == 'ACTIVE' ? 'bg-success' :
                                      membership.status == 'PENDING' ? 'bg-warning text-dark' :
                                      'bg-secondary'}">
                                            ${membership.status}
                                    </span>

                                    <p class="text-muted small mt-2 mb-0">
                                        HSD: ${membership.endDate}
                                    </p>
                                </c:when>

                                <c:otherwise>
                                    <p class="text-muted">Bạn chưa có gói tập</p>
                                    <a href="${pageContext.request.contextPath}/member/packages"
                                       class="btn btn-sm btn-primary">
                                        Đăng ký ngay
                                    </a>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>
                </div>

                <!-- LỚP -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">

                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-success-subtle me-3">
                                    <i class="bi bi-calendar-check text-success fs-4"></i>
                                </div>
                                <h6 class="mb-0">Lớp đang theo học</h6>
                            </div>

                            <p class="fw-bold fs-3 mb-0">
                                ${classRegistrations.size()}
                            </p>

                            <a href="${pageContext.request.contextPath}/member/schedules"
                               class="btn btn-sm btn-outline-success mt-2">
                                Xem lịch
                            </a>

                        </div>
                    </div>
                </div>

                <!-- TÀI KHOẢN -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">

                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-warning-subtle me-3">
                                    <i class="bi bi-person-circle text-warning fs-4"></i>
                                </div>
                                <h6 class="mb-0">Tài khoản</h6>
                            </div>

                            <p class="mb-1">${member.email}</p>

                            <p class="text-muted small">
                                ${member.phone != null ? member.phone : "Chưa có SĐT"}
                            </p>

                            <a href="${pageContext.request.contextPath}/member/profile"
                               class="btn btn-sm btn-outline-warning">
                                Cập nhật
                            </a>

                        </div>
                    </div>
                </div>

            </div>

            <!-- DANH SÁCH LỚP -->
            <div class="card border-0 shadow-sm">

                <div class="card-header bg-white border-0 pt-3">
                    <h5><i class="bi bi-list-check me-2"></i>Lớp học tham gia</h5>
                </div>

                <div class="card-body p-0">

                    <c:choose>
                        <c:when test="${empty classRegistrations}">
                            <p class="text-muted text-center py-4">
                                Bạn chưa đăng ký lớp nào
                            </p>
                        </c:when>

                        <c:otherwise>
                            <div class="table-responsive">

                                <table class="table table-hover mb-0">

                                    <thead class="table-light">
                                    <tr>
                                        <th>Lớp</th>
                                        <th>Dịch vụ</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                    </thead>

                                    <tbody>

                                    <c:forEach var="cr" items="${classRegistrations}">
                                        <tr>
                                            <td>${cr.gymClass.className}</td>
                                            <td>${cr.service.serviceName}</td>
                                            <td>${cr.startDate}</td>

                                            <td>
                                            <span class="badge
                                                ${cr.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                                    ${cr.status}
                                            </span>
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
