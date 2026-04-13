<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gói tập của tôi | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-award me-2"></i>Gói hội viên của tôi</h2>

            <!-- ALERT -->
            <c:if test="${success == 'membership_cancelled'}">
                <div class="alert alert-info alert-dismissible fade show">
                    Đã huỷ gói tập thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${error == 'cannot_cancel'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Không thể huỷ gói đang hoạt động.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- ACTIVE -->
            <c:if test="${not empty membership}">
                <div class="mb-4">
                    <h5 class="fw-bold text-success">
                        <i class="bi bi-check-circle me-2"></i>Gói đang hoạt động
                    </h5>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4">

                            <div class="d-flex justify-content-between mb-3">
                                <h5 class="fw-bold mb-0">
                                        ${membership.gymPackage.packageName}
                                </h5>

                                <span class="badge bg-success fs-6">
                                        ${membership.status}
                                </span>
                            </div>

                            <table class="table table-borderless mb-0">
                                <tr>
                                    <td class="text-muted ps-0">Ngày bắt đầu:</td>
                                    <td>${membership.startDate}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted ps-0">Ngày hết hạn:</td>
                                    <td>${membership.endDate}</td>
                                </tr>
                            </table>

                            <div class="mt-3 d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/member/payment?membershipId=${membership.membershipId}"
                                   class="btn btn-outline-primary btn-sm">
                                    Xem thanh toán
                                </a>
                                <a href="${pageContext.request.contextPath}/member/packages"
                                   class="btn btn-outline-secondary btn-sm">
                                    Gia hạn
                                </a>
                            </div>

                        </div>
                    </div>
                </div>
            </c:if>

            <!-- PENDING -->
            <c:if test="${not empty pendingMembership}">
                <div class="row g-4">

                    <h5 class="fw-bold text-warning">
                        <i class="bi bi-clock me-2"></i>Gói đang chờ duyệt
                    </h5>

                    <div class="col-md-5">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">

                                <div class="d-flex justify-content-between mb-3">
                                    <h5 class="fw-bold mb-0">
                                            ${pendingMembership.gymPackage.packageName}
                                    </h5>

                                    <span class="badge bg-warning text-dark fs-6">
                                            ${pendingMembership.status}
                                    </span>
                                </div>

                                <table class="table table-borderless mb-0">
                                    <tr>
                                        <td class="text-muted ps-0">Ngày bắt đầu:</td>
                                        <td>${pendingMembership.startDate}</td>
                                    </tr>
                                    <tr>
                                        <td class="text-muted ps-0">Ngày hết hạn:</td>
                                        <td>${pendingMembership.endDate}</td>
                                    </tr>
                                </table>

                                <div class="alert alert-warning small mt-3">
                                    Gói đang chờ admin xác nhận thanh toán.
                                </div>

                                <div class="mt-3 d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/member/payment?membershipId=${pendingMembership.membershipId}"
                                       class="btn btn-outline-primary btn-sm">
                                        Thanh toán
                                    </a>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/member/cancel-membership">
                                        <input type="hidden" name="membershipId" value="${pendingMembership.membershipId}">
                                        <button class="btn btn-outline-danger btn-sm">
                                            Huỷ
                                        </button>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- PAYMENT -->
                    <div class="col-md-7">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white border-0">
                                <h5>Thanh toán</h5>
                            </div>

                            <div class="card-body">

                                <c:if test="${not empty payment}">
                                    <p><strong>Số tiền:</strong>
                                        <fmt:formatNumber value="${payment.amount}" groupingUsed="true"/>đ
                                    </p>

                                    <p><strong>Trạng thái:</strong> ${payment.status}</p>

                                    <c:if test="${not empty payment.proofImage}">
                                        <img src="<c:url value='${payment.proofImage}'/>"
                                             class="img-thumbnail"
                                             style="max-height:200px;">
                                    </c:if>
                                </c:if>

                                <c:if test="${empty payment}">
                                    <a href="${pageContext.request.contextPath}/member/payment?membershipId=${pendingMembership.membershipId}"
                                       class="btn btn-primary">
                                        Thanh toán ngay
                                    </a>
                                </c:if>

                            </div>
                        </div>
                    </div>

                </div>
            </c:if>

            <!-- EMPTY -->
            <c:if test="${empty membership and empty pendingMembership}">
                <div class="text-center py-5">
                    <h5 class="text-muted">Bạn chưa có gói tập</h5>
                    <a href="${pageContext.request.contextPath}/member/packages"
                       class="btn btn-primary mt-2">
                        Đăng ký ngay
                    </a>
                </div>
            </c:if>

        </main>
    </div>


</div>
</body>
</html>
