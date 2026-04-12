<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-clock-history me-2"></i>Lịch sử đăng ký</h2>

            <%-- Tabs --%>
            <ul class="nav nav-tabs mb-4" id="historyTab">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-membership">
                        <i class="bi bi-award me-1"></i>Gói tập
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-payment">
                        <i class="bi bi-receipt me-1"></i>Thanh toán
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <%-- Tab: Gói tập --%>
                <div class="tab-pane fade show active" id="tab-membership">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty memberships}">
                                    <p class="text-center text-muted py-4">Chưa có lịch sử đăng ký gói tập.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                            <tr>
                                                <th>#</th><th>Gói tập</th><th>Ngày bắt đầu</th>
                                                <th>Ngày hết hạn</th><th>Trạng thái</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="m" items="${memberships}" varStatus="st">
                                                <tr>
                                                    <td>${st.count}</td>
                                                    <td><strong>${m.pkg.packageName}</strong></td>
                                                    <td>${m.startDate}</td>
                                                    <td>${m.endDate}</td>
                                                    <td>
                                                        <span class="badge
                                                            <c:choose>
                                                                <c:when test='${m.status == "active"}'>bg-success</c:when>
                                                                <c:when test='${m.status == "pending"}'>bg-warning text-dark</c:when>
                                                                <c:otherwise>bg-secondary</c:otherwise>
                                                            </c:choose>">
                                                                ${m.status}
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
                </div>

                <%-- Tab: Thanh toán --%>
                <div class="tab-pane fade" id="tab-payment">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty payments}">
                                    <p class="text-center text-muted py-4">Chưa có lịch sử thanh toán.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                            <tr>
                                                <th>#</th><th>Gói tập</th><th>Số tiền</th>
                                                <th>Ngày TT</th><th>Trạng thái</th><th>Minh chứng</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="p" items="${payments}" varStatus="st">
                                                <tr>
                                                    <td>${st.count}</td>
                                                    <td>${p.membership.pkg.packageName}</td>
                                                    <td class="fw-semibold text-primary">
                                                        <fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/>đ
                                                    </td>
                                                    <td>${p.paymentDate}</td>
                                                    <td>
                                                        <span class="badge
                                                            <c:choose>
                                                                <c:when test='${p.status == "approved"}'>bg-success</c:when>
                                                                <c:when test='${p.status == "pending"}'>bg-warning text-dark</c:when>
                                                                <c:otherwise>bg-danger</c:otherwise>
                                                            </c:choose>">
                                                                ${p.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty p.proofImage}">
                                                            <a href="${pageContext.request.contextPath}${p.proofImage}"
                                                               target="_blank" class="btn btn-sm btn-outline-secondary">
                                                                <i class="bi bi-image"></i> Xem
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${empty p.proofImage}">
                                                            <span class="text-muted small">Chưa có</span>
                                                        </c:if>
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
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
