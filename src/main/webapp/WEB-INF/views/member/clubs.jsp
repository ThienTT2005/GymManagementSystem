<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi nhánh | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-building me-2"></i>Danh sách chi nhánh</h2>

            <div class="row g-4">
                <c:forEach var="club" items="${clubs}">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm h-100">
                            <c:choose>
                                <c:when test="${not empty club.image}">
                                    <img src="${pageContext.request.contextPath}${club.image}"
                                         class="card-img-top" style="height:180px;object-fit:cover;" alt="${club.clubName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-secondary text-white d-flex align-items-center justify-content-center"
                                         style="height:180px;">
                                        <i class="bi bi-building fs-1"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body">
                                <h5 class="card-title fw-bold">${club.clubName}</h5>
                                <p class="text-muted small mb-1">
                                    <i class="bi bi-geo-alt me-1"></i>${club.address}
                                </p>
                                <p class="text-muted small mb-2">
                                    <i class="bi bi-telephone me-1"></i>${club.phone}
                                </p>
                                <p class="card-text small">${club.description}</p>
                            </div>
                            <div class="card-footer bg-white border-0 pb-3">
                                <a href="${pageContext.request.contextPath}/member/schedules?clubId=${club.clubId}"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-calendar3 me-1"></i>Xem lịch tập
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty clubs}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-building fs-1 d-block mb-2"></i>
                        Chưa có chi nhánh nào.
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
