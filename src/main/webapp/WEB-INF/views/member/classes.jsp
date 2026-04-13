<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký lớp học | Gym Member</title>
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0"><i class="bi bi-grid me-2"></i>Danh sách lớp học</h2>
                <a href="${pageContext.request.contextPath}/member/schedules"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-calendar-check me-1"></i>Lịch tập của tôi
                </a>
            </div>

            <c:if test="${success == 'class_registered'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>Đăng ký lớp thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${error == 'already_registered'}">
                <div class="alert alert-warning alert-dismissible fade show">
                    Bạn đã đăng ký lớp này rồi.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${error == 'class_full'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Lớp đã đầy, vui lòng chọn lớp khác.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty classes}">
                        <div class="col-12 text-center py-5 text-muted">
                            <i class="bi bi-grid fs-1 d-block mb-2"></i>
                            Chưa có lớp học nào.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="cls" items="${classes}">
                            <div class="col-md-4">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-body">
                                        <h5 class="fw-bold">${cls.className}</h5>

                                        <p class="text-muted small mb-1">
                                            <i class="bi bi-person me-1"></i>
                                                ${cls.trainerName}
                                        </p>

                                        <p class="text-muted small mb-2">
                                            <i class="bi bi-tag me-1"></i>
                                                ${cls.service != null ? cls.service.serviceName : 'Chưa có dịch vụ'}
                                        </p>

                                        <div class="d-flex align-items-center gap-2 mb-3">
                                            <i class="bi bi-people"></i>
                                            <span class="${cls.currentMember >= cls.maxMember ? 'text-danger' : 'text-success'} fw-semibold">
                                            ${cls.currentMember}/${cls.maxMember} học viên
                                        </span>
                                        </div>

                                        <p class="text-muted small">${cls.description}</p>
                                    </div>

                                    <div class="card-footer bg-white border-0 pb-3">
                                        <c:choose>
                                            <c:when test="${cls.currentMember >= cls.maxMember}">
                                                <button class="btn btn-secondary w-100" disabled>
                                                    Đã đầy lớp
                                                </button>
                                            </c:when>

                                            <c:otherwise>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/member/register-class">
                                                    <input type="hidden" name="classId" value="${cls.classId}">
                                                    <button type="submit" class="btn btn-success w-100">
                                                        <i class="bi bi-plus-circle me-1"></i>Đăng ký lớp
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>