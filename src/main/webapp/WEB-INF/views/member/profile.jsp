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

            <c:if test="${param.success == true}">
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
                        <div class="avatar-circle mx-auto mb-3">
                            <c:choose>
                                <c:when test="${not empty member.avatar}">
                                    <img src="<c:url value='/${member.avatar}'/>"
                                         class="rounded-circle"
                                         style="width:90px;height:90px;object-fit:cover;"
                                         alt="avatar">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:90px;height:90px;border-radius:50%;background:#667eea;display:flex;align-items:center;justify-content:center;margin:auto;">
                                        <span style="font-size:2rem;color:white;">&#128100;</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h5 class="fw-bold">${member.fullname}</h5>
                        <p class="text-muted">@${member.fullname}</p>
                        <span class="badge bg-success">Member</span>
                        <hr>
                        <p class="small text-muted mb-0">
                            <i class="bi bi-calendar3 me-1"></i>
                            Tham gia:
                            <c:if test="${not empty member.createdAt}">
                                ${member.createdAt}
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
                            <form method="post"
                                  action="${pageContext.request.contextPath}/member/update-profile"
                                  enctype="multipart/form-data">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Họ và tên</label>
                                        <input type="text" name="fullName" class="form-control"
                                               value="${member.fullname}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Email</label>
                                        <input type="email" name="email" class="form-control"
                                               value="${member.email}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Số điện thoại</label>
                                        <input type="tel" name="phone" class="form-control"
                                               value="${member.phone}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Giới tính</label>
                                        <select name="gender" class="form-select">
                                            <option value="">-- Chọn --</option>
                                            <option value="Male"   ${member.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                                            <option value="Female" ${member.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                            <option value="Other"  ${member.gender == 'Other'  ? 'selected' : ''}>Khác</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Ngày sinh</label>
                                        <input type="date" name="dob" class="form-control"
                                               value="${not empty member.dob ? member.dob : ''}">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Địa chỉ</label>
                                        <textarea name="address" class="form-control" rows="2">${member.address}</textarea>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Ảnh đại diện</label>
                                        <input type="file" name="avatar" class="form-control"
                                               accept="image/jpeg,image/png,image/jpg"
                                               onchange="previewImage(this)">
                                        <div class="form-text">Chấp nhận: JPG, PNG. Tối đa 5MB.</div>
                                    </div>
                                    <div class="col-12">
                                        <div id="preview" class="d-none mt-2">
                                            <img id="previewImg"
                                                 class="img-thumbnail"
                                                 style="max-height:200px;">
                                        </div>
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
                            <p class="mb-1"><strong>Tên đăng nhập:</strong> ${member.user.username}</p>
                            <p class="text-muted small">Tên đăng nhập không thể thay đổi.</p>
                        </div>
                    </div>
                </div>
            </div>
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
