<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hội viên | Gym Member</title>
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
            <h2 class="mb-1"><i class="bi bi-bag me-2"></i>Hội viên</h2>
            <p class="text-muted mb-4">Chọn gói hội viên phù hợp với bạn.</p>

            <c:if test="${param.error == 'already_active'}">
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Gói hội viên của bạn vẫn đang hoạt động. Bạn có thể <strong>gia hạn</strong> sau khi gói hiện tại hết hạn,
                    hoặc vào <a href="${pageContext.request.contextPath}/member/my-membership">Gói hội viên của tôi</a> để gia hạn.
                </div>
            </c:if>
            <c:if test="${param.error == 'having_pending'}">
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Bạn đăng có gói hội viên đang trong trạng thái chờ duyệt, bạn phải đợi đến khi admin duyệt gói hội viên của bạn thì bạn mới gia hạn/đăng ký gói hội viên mới được,
                    hoặc bạn có thể vào <a href="${pageContext.request.contextPath}/member/my-membership">Gói hội viên của tôi</a> để huỷ gói hội viên đang được chờ duyệt.
                </div>
            </c:if>

            <%-- Gói hiện tại --%>
            <c:if test="${not empty activeMembership}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>
                        Bạn đang dùng gói <strong>${activeMembership.pkg.packageName}</strong>
                        (${activeMembership.status}).
                        Gói hội viên của bạn có hạn tới: <strong>${activeMembership.endDate}</strong>

                    </div>
                </div>
            </c:if>
            <c:if test="${not empty pendingMembership}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>
                        Bạn đang có gói <strong>${pendingMembership.pkg.packageName}</strong>
                        (${pendingMembership.status}) đang chờ được duyệt. Bạn không thể gia hạn/đăng ký cho đến khi gói này được duyệt.
                        Gói hội viên này sẽ có hạn tới: <strong>${pendingMembership.endDate}</strong>

                    </div>
                </div>
            </c:if>

            <div class="row g-4 justify-content-center">
                <c:forEach var="pkg" items="${packages}" varStatus="st">
                    <div class="col-md-3">
                        <div class="card border-0 shadow h-100 ${st.index == 2 ? 'border-primary border-2 position-relative' : ''}">
                            <c:if test="${st.index == 2}">
                                <div class="position-absolute top-0 start-50 translate-middle">
                                    <span class="badge bg-primary px-3 py-2">PHỔ BIẾN NHẤT</span>
                                </div>
                            </c:if>
                            <div class="card-body text-center pt-4">
                                <c:if test="${not empty pkg.image}">
                                    <img src="${pageContext.request.contextPath}${pkg.image}"
                                         class="mb-3" style="height:60px;object-fit:contain;" alt="${pkg.packageName}">
                                </c:if>
                                <h5 class="fw-bold">${pkg.packageName}</h5>
                                <div class="my-3">
                                    <span class="display-6 fw-bold text-primary">
                                        <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true"/>đ
                                    </span>
                                    <p class="text-muted small">/ ${pkg.durationMonth} tháng</p>
                                </div>
                                <hr>
                                <p class="text-muted small">${pkg.description}</p>
                            </div>
                            <div class="card-footer bg-white border-0 pb-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty activeMembership}">
                                        <%-- Có gói rồi => Gia hạn --%>
                                        <form method="post" action="${pageContext.request.contextPath}/member/register-package">
                                            <input type="hidden" name="packageId" value="${pkg.packageId}">
                                            <input type="hidden" name="action" value="renew">
                                            <button type="submit" class="btn btn-outline-primary w-100">
                                                <i class="bi bi-arrow-clockwise me-1"></i>Gia hạn
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Chưa có gói => Đăng ký --%>
                                        <a href="${pageContext.request.contextPath}/member/register-package?packageId=${pkg.packageId}"
                                           class="btn btn-primary w-100">
                                            <i class="bi bi-cart-plus me-1"></i>Đăng ký
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty packages}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-bag fs-1 d-block mb-2"></i>Chưa có gói tập nào.
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
