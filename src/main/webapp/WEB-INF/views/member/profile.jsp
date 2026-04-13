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

            <!-- ALERT -->
            <c:if test="${param.success == true}">
                <div class="alert alert-success alert-dismissible fade show">
                    Cập nhật thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                        ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">

                <!-- PROFILE CARD -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm text-center p-4">

                        <div class="avatar-circle mx-auto mb-3">
                            <c:choose>
                                <c:when test="${not empty member.avatar}">
                                    <img src="<c:url value='/${member.avatar}'/>"
                                         class="rounded-circle"
                                         style="width:90px;height:90px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:90px;height:90px;border-radius:50%;background:#667eea;display:flex;align-items:center;justify-content:center;margin:auto;">
                                        <span style="font-size:2rem;color:white;">👤</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h5 class="fw-bold">${member.fullname}</h5>
                        <p class="text-muted">@${member.user.username}</p>

                        <span class="badge bg-success">Member</span>

                        <hr>

                        <p class="small text-muted mb-0">
                            Tham gia:
                            <c:if test="${not empty member.createdAt}">
                                ${member.createdAt}
                            </c:if>
                        </p>

                    </div>
                </div>

                <!-- FORM -->
                <div class="col-md-8">
                    <div class="card border-0 shadow-sm">

                        <div class="card-header bg-white border-0">
                            <h5>Cập nhật thông tin</h5>
                        </div>

                        <div class="card-body">

                            <form method="post"
                                  action="${pageContext.request.contextPath}/member/update-profile"
                                  enctype="multipart/form-data">

                                <div class="row g-3">

                                    <div class="col-12">
                                        <label class="form-label">Họ và tên</label>
                                        <input type="text" name="fullName"
                                               class="form-control"
                                               value="${member.fullname}" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label>Email</label>
                                        <input type="email" name="email"
                                               class="form-control"
                                               value="${member.email}">
                                    </div>

                                    <div class="col-md-6">
                                        <label>SĐT</label>
                                        <input type="text" name="phone"
                                               class="form-control"
                                               value="${member.phone}">
                                    </div>

                                    <div class="col-md-6">
                                        <label>Giới tính</label>
                                        <select name="gender" class="form-select">
                                            <option value="">-- Chọn --</option>
                                            <option value="Male" ${member.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                            <option value="Female" ${member.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                            <option value="Other" ${member.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label>Ngày sinh</label>
                                        <input type="date" name="dob"
                                               class="form-control"
                                               value="${member.dob}">
                                    </div>

                                    <div class="col-12">
                                        <label>Địa chỉ</label>
                                        <textarea name="address"
                                                  class="form-control">${member.address}</textarea>
                                    </div>

                                    <div class="col-md-6">
                                        <label>Avatar</label>
                                        <input type="file" name="avatar"
                                               class="form-control">
                                    </div>

                                    <div class="col-12">
                                        <button class="btn btn-primary">
                                            Lưu thay đổi
                                        </button>
                                    </div>

                                </div>

                            </form>

                        </div>
                    </div>

                    <!-- ACCOUNT -->
                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">
                            <p><strong>Username:</strong> ${member.user.username}</p>
                        </div>
                    </div>

                </div>

            </div>

        </main>
    </div>

</div>

</body>
</html>
