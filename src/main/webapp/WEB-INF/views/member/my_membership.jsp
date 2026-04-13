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

            <c:if test="${success == 'membership_cancelled'}">
                <div class="alert alert-info alert-dismissible fade show">
                    Đã huỷ gói tập thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${error == 'cannot_cancel'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Không thể huỷ gói tập đang hoạt động. Chỉ có thể huỷ khi gói đang chờ duyệt.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${success == 'uploaded'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>
                    Upload minh chứng thành công! Admin sẽ xác nhận sớm.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${error == 'upload_failed'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Upload minh chứng thất bại! Xin hãy thử lại.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty membership}">
                <div class="mb-4">
                    <h5 class="fw-bold text-success">
                        <i class="bi bi-check-circle me-2"></i>Gói đang hoạt động
                    </h5>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <h5 class="fw-bold mb-0">${membership.pkg.packageName}</h5>
                                <span class="badge bg-success fs-6">active</span>
                            </div>

                            <table class="table table-borderless mb-0">
                                <tr>
                                    <td class="text-muted ps-0">Ngày bắt đầu:</td>
                                    <td class="fw-semibold">${membership.startDate}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted ps-0">Ngày hết hạn:</td>
                                    <td class="fw-semibold">${membership.endDate}</td>
                                </tr>
                            </table>
                            <div class="mt-3 d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/member/payment?membershipId=${membership.membershipId}"
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-credit-card me-1"></i>Xem thanh toán
                                </a>
                                <a href="${pageContext.request.contextPath}/member/packages"
                                   class="btn btn-outline-secondary btn-sm">
                                    <i class="bi bi-arrow-clockwise me-1"></i>Gia hạn
                                </a>
                            </div>

                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty pendingMembership}">
                <div class="row g-4">
                            <%-- Thông tin gói --%>
                    <h5 class="fw-bold text-success">
                        <i class="bi bi-check-circle me-2"></i>Gói đang chờ duyệt
                    </h5>
                        <div class="col-md-5">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="fw-bold mb-0"><p>${pendingMembership.pkg.packageName}</p></h5>
                                        <span class="badge fs-6
                                            <c:choose>
                                                <c:when test='${pendingMembership.status == "pending"}'>bg-warning text-dark</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose>">
                                                ${pendingMembership.status}
                                        </span>
                                    </div>
                                    <table class="table table-borderless mb-0">
                                        <tr>
                                            <td class="text-muted ps-0">Ngày bắt đầu:</td>
                                            <td class="fw-semibold">${pendingMembership.startDate}</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Ngày hết hạn:</td>
                                            <td class="fw-semibold">${pendingMembership.endDate}</td>
                                        </tr>
                                    </table>

<%--                                    <c:if test="${pendingMembership.status == 'pending'}">--%>
                                    <div class="alert alert-warning small mt-3 mb-0">
                                        <i class="bi bi-clock me-1"></i>
                                        Gói tập đang chờ xác nhận thanh toán từ Admin.
                                    </div>
<%--                                    </c:if>--%>

                                    <div class="mt-3 d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/member/payment?membershipId=${pendingMembership.membershipId}"
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-credit-card me-1"></i>Xem thanh toán
                                        </a>
                                            <%-- Chỉ cho huỷ khi status = pending --%>
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/member/cancel-membership"
                                              onsubmit="return confirm('Bạn có chắc muốn huỷ yêu cầu này không?')">
                                            <input type="hidden" name="membershipId" value="${pendingMembership.membershipId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">Huỷ yêu cầu</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                            <%-- Trạng thái thanh toán --%>
                        <div class="col-md-7">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white border-0 pt-3">
                                    <h5 class="mb-0"><i class="bi bi-receipt me-2"></i>Trạng thái thanh toán</h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty payment}">
                                            <div class="d-flex align-items-center gap-3 mb-3">
                                                <div>
                                                    <span class="badge fs-6
                                                        <c:choose>
                                                            <c:when test='${payment.status == "approved"}'>bg-success</c:when>
                                                            <c:when test='${payment.status == "pending"}'>bg-warning text-dark</c:when>
                                                            <c:otherwise>bg-danger</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${payment.status == 'approved'}">✓ Đã duyệt</c:when>
                                                            <c:when test="${payment.status == 'pending'}">⏳ Đang chờ duyệt</c:when>
                                                            <c:otherwise>✗ Từ chối</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                            <p class="mb-1"><strong>Số tiền:</strong>
                                                <fmt:formatNumber value="${payment.amount}" type="number" groupingUsed="true"/>đ
                                            </p>
                                            <p class="mb-3"><strong>Ngày thanh toán:</strong> ${payment.paymentDate}</p>

                                            <c:if test="${not empty payment.proofImage}">
                                                <p class="fw-semibold mb-2">Minh chứng đã upload:</p>
                                                <img src="<c:url value='${payment.proofImage}'/>"
                                                     class="img-thumbnail"
                                                     style="max-height:200px;"
                                                     alt="Minh chứng thanh toán đã upload">
                                            </c:if>
                                            <c:if test="${empty payment.proofImage}">
                                                <hr>
                                                <p class="fw-semibold">Upload minh chứng thanh toán:</p>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/member/upload-proof"
                                                      enctype="multipart/form-data">
                                                    <input type="hidden" name="membershipId" value="${pendingMembership.membershipId}">
                                                    <div class="mb-3">
                                                        <input type="file" name="proofImage" class="form-control"
                                                               accept="image/jpeg,image/png,image/jpg" required
                                                               onchange="previewImage(this)">
                                                        <div class="form-text">Chấp nhận: JPG, PNG. Tối đa 5MB.</div>
                                                    </div>
                                                    <div id="preview" class="mb-3 d-none">
                                                        <img id="previewImg" src="#" alt="Preview"
                                                             class="img-thumbnail" style="max-height:150px;">
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Gửi minh chứng</button>
                                                </form>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-warning">
                                                Chưa có thông tin thanh toán.
                                                <a href="${pageContext.request.contextPath}/member/payment?membershipId=${pendingMembership.membershipId}">
                                                    Thanh toán ngay
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
            </c:if>
                <c:if test="${empty membership and empty pendingMembership}">
                    <div class="text-center py-5">
                        <i class="bi bi-bag fs-1 text-muted d-block mb-3"></i>
                        <h5 class="text-muted">Bạn chưa có gói tập nào</h5>
                        <a href="${pageContext.request.contextPath}/member/packages" class="btn btn-primary mt-2">
                            <i class="bi bi-cart-plus me-1"></i>Đăng ký gói tập
                        </a>
                    </div>
                </c:if>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                document.getElementById('previewImg').src = e.target.result;
                document.getElementById('preview').classList.remove('d-none');
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>
