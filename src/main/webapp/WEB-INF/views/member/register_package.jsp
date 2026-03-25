<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận đăng ký | Gym Member</title>
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

            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/member/packages">Gói tập</a></li>
                    <li class="breadcrumb-item active">Xác nhận đăng ký</li>
                </ol>
            </nav>

            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card border-0 shadow">
                        <div class="card-header bg-primary text-white text-center py-3">
                            <h5 class="mb-0"><i class="bi bi-cart-check me-2"></i>Xác nhận đăng ký gói tập</h5>
                        </div>
                        <div class="card-body p-4">
                            <c:choose>
                                <c:when test="${not empty selectedPackage}">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td class="fw-semibold text-muted">Gói tập:</td>
                                            <td class="fw-bold fs-5">${selectedPackage.packageName}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold text-muted">Thời hạn:</td>
                                            <td>${selectedPackage.durationMonth} tháng</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold text-muted">Giá:</td>
                                            <td class="fw-bold text-primary fs-5">
                                                <fmt:formatNumber value="${selectedPackage.price}" type="number" groupingUsed="true"/>đ
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold text-muted">Mô tả:</td>
                                            <td>${selectedPackage.description}</td>
                                        </tr>
                                    </table>

                                    <div class="alert alert-warning small">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Sau khi đăng ký, bạn cần <strong>upload minh chứng thanh toán</strong>
                                        để Admin duyệt và kích hoạt gói tập.
                                    </div>

                                    <form method="post" action="${pageContext.request.contextPath}/member/register-package">
                                        <input type="hidden" name="packageId" value="${selectedPackage.packageId}">
                                        <input type="hidden" name="action" value="register">
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg">
                                                <i class="bi bi-check-circle me-2"></i>Xác nhận đăng ký
                                            </button>
                                            <a href="${pageContext.request.contextPath}/member/packages" class="btn btn-outline-secondary">
                                                Quay lại
                                            </a>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <p class="text-muted">Gói tập không tồn tại.</p>
                                        <a href="${pageContext.request.contextPath}/member/packages" class="btn btn-primary">
                                            Xem danh sách gói tập
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
