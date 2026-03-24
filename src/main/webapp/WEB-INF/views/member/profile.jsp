<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-person-circle me-2"></i>Thông tin cá nhân</h2>

            <c:if test="${param.success == '1'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i>Cập nhật thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-circle me-2"></i>${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <%-- Card thông tin --%>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm text-center p-4">
                        <div class="mb-3">
                            <div class="avatar-circle mx-auto">
                                <i class="bi bi-person-fill fs-1 text-white"></i>
                            </div>
                        </div>
                        <h5 class="fw-bold">${user.fullName}</h5>
                        <p class="text-muted">@${user.username}</p>
                        <span class="badge bg-success">Member</span>
                        <hr>
                        <p class="small text-muted mb-0">
                            <i class="bi bi-calendar3 me-1"></i>
                            Tham gia:
                            <c:if test="${not empty user.createdAt}">
                                ${user.createdAt}
                            </c:if>
                        </p>
                    </div>
                </div>

                <%-- Form cập nhật --%>
                <div class="col-md-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white border-0 pt-3">
                            <h5 class="mb-0">Cập nhật thông tin</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/member/update-profile" novalidate>
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Họ và tên</label>
                                        <input type="text" name="fullName" class="form-control"
                                               value="${user.fullName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Email</label>
                                        <input type="email" name="email" class="form-control"
                                               value="${user.email}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Số điện thoại</label>
                                        <input type="tel" name="phone" class="form-control"
                                               value="${user.phone}">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Địa chỉ</label>
                                        <textarea name="address" class="form-control" rows="2">${user.address}</textarea>
                                    </div>
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-save me-1"></i>Lưu thay đổi
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Tên đăng nhập (readonly) --%>
                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">
                            <h6 class="fw-bold mb-3"><i class="bi bi-shield-lock me-2"></i>Thông tin tài khoản</h6>
                            <p class="mb-1"><strong>Tên đăng nhập:</strong> ${user.username}</p>
                            <p class="text-muted small">Tên đăng nhập không thể thay đổi.</p>
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
