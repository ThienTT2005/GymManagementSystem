<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gói hội viên | Gym Member</title>

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

            <h2><i class="bi bi-bag me-2"></i>Gói hội viên</h2>

            <!-- THÔNG BÁO -->
            <c:if test="${param.error == 'already_active'}">
                <div class="alert alert-warning">
                    Bạn đang có gói hoạt động. Hãy gia hạn sau khi hết hạn.
                </div>
            </c:if>

            <c:if test="${param.error == 'having_pending'}">
                <div class="alert alert-warning">
                    Bạn đang có gói chờ duyệt. Không thể đăng ký thêm.
                </div>
            </c:if>

            <!-- ACTIVE -->
            <c:if test="${not empty activeMembership}">
                <div class="alert alert-info">
                    Bạn đang dùng:
                    <strong>${activeMembership.gymPackage.packageName}</strong>
                    (${activeMembership.status})
                    - HSD: ${activeMembership.endDate}
                </div>
            </c:if>

            <!-- PENDING -->
            <c:if test="${not empty pendingMembership}">
                <div class="alert alert-info">
                    Gói đang chờ:
                    <strong>${pendingMembership.gymPackage.packageName}</strong>
                    (${pendingMembership.status})
                </div>
            </c:if>

            <!-- LIST -->
            <div class="row g-4">

                <c:forEach var="pkg" items="${packages}">
                    <div class="col-md-3">

                        <div class="card shadow-sm h-100 text-center">

                            <div class="card-body">

                                <h5>${pkg.packageName}</h5>

                                <h3 class="text-primary">
                                    <fmt:formatNumber value="${pkg.price}" groupingUsed="true"/>đ
                                </h3>

                                <p>${pkg.durationMonths} tháng</p>

                                <p class="text-muted small">${pkg.description}</p>

                            </div>

                            <div class="card-footer bg-white border-0">

                                <c:choose>

                                    <c:when test="${not empty activeMembership}">
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/member/register-package">
                                            <input type="hidden" name="packageId" value="${pkg.packageId}">
                                            <input type="hidden" name="action" value="renew">

                                            <button class="btn btn-outline-primary w-100">
                                                Gia hạn
                                            </button>
                                        </form>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/member/register-package?packageId=${pkg.packageId}"
                                           class="btn btn-primary w-100">
                                            Đăng ký
                                        </a>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>

                    </div>
                </c:forEach>

            </div>

        </main>
    </div>

</div>

</body>
</html>
