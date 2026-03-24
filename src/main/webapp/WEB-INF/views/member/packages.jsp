<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gói tập | Gym Member</title>
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
            <h2 class="mb-1"><i class="bi bi-bag me-2"></i>Gói tập</h2>
            <p class="text-muted mb-4">Chọn gói tập phù hợp với bạn.</p>

            <c:if test="${param.error == 'already_active'}">
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Bạn đang có gói tập hoạt động. Bạn có thể <strong>gia hạn</strong> sau khi gói hiện tại hết hạn,
                    hoặc vào <a href="${pageContext.request.contextPath}/member/my-package">Gói tập của tôi</a> để gia hạn.
                </div>
            </c:if>

            <%-- Gói hiện tại --%>
            <c:if test="${not empty currentMembership}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>
                        Bạn đang dùng gói <strong>${currentMembership.pkg.packageName}</strong>
                        (${currentMembership.status}).
                        Hết hạn: <strong>${currentMembership.endDate}</strong>
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
                                    <c:when test="${not empty currentMembership}">
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
