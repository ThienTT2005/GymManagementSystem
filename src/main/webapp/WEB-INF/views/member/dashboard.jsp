<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            <h2 class="mb-4">Xin chào, <strong><c:out value="${sessionScope.loggedInUser.fullName}" /></strong>!</h2>

            <%-- CARD: Gói tập hiện tại --%>
            <div class="row g-4 mb-4">
                <div class="col-md-6">
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
                                    <p class="fw-bold fs-5 mb-1"><c:out value="${membership.pkg.packageName}" /></p>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test='${membership.status == "active"}'>bg-success</c:when>
                                            <c:when test='${membership.status == "pending"}'>bg-warning text-dark</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                            <c:out value="${membership.status}" />
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

                <div class="col-md-6">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="icon-box bg-warning-subtle me-3">
                                    <i class="bi bi-person-circle text-warning fs-4"></i>
                                </div>
                                <h6 class="card-title mb-0">Tài khoản</h6>
                            </div>
                            <p class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loggedInUser.email}">
                                        <c:out value="${sessionScope.loggedInUser.email}" />
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </p>
                            <p class="text-muted small mb-2">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loggedInUser.phone}">
                                        <c:out value="${sessionScope.loggedInUser.phone}" />
                                    </c:when>
                                    <c:otherwise>Chưa cập nhật SĐT</c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/member/profile" class="btn btn-sm btn-outline-warning">Cập nhật</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body py-4">
                    <h5 class="mb-2"><i class="bi bi-info-circle me-2"></i>Luyện tập &amp; dịch vụ</h5>
                    <p class="text-muted mb-0">
                        Xem các chương trình tập luyện và đăng ký tư vấn trên trang dịch vụ công khai của phòng gym,
                        hoặc đăng ký gói tập trực tiếp trong mục &quot;Đăng ký gói tập&quot;.
                    </p>
                    <a href="${pageContext.request.contextPath}/services" class="btn btn-sm btn-outline-primary mt-3">Xem dịch vụ</a>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
