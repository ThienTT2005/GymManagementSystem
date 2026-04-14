<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu | Gym Member</title>
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
            <h2 class="mb-4"><i class="bi bi-shield-lock me-2"></i>Đổi mật khẩu</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <form method="post"
                                  action="${pageContext.request.contextPath}/member/change-password"
                                  novalidate id="changePasswordForm">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Mật khẩu hiện tại</label>
                                    <div class="input-group">
                                        <input type="password" name="currentPassword"
                                               id="currentPassword"
                                               class="form-control" required>
                                        <button type="button" class="btn btn-outline-secondary"
                                                onclick="togglePassword('currentPassword')">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Mật khẩu mới</label>
                                    <div class="input-group">
                                        <input type="password" name="newPassword"
                                               id="newPassword"
                                               class="form-control" required minlength="6"
                                               oninput="checkMatch()">
                                        <button type="button" class="btn btn-outline-secondary"
                                                onclick="togglePassword('newPassword')">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Tối thiểu 6 ký tự.</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-semibold">Xác nhận mật khẩu mới</label>
                                    <div class="input-group">
                                        <input type="password" name="confirmPassword"
                                               id="confirmPassword"
                                               class="form-control" required
                                               oninput="checkMatch()">
                                        <button type="button" class="btn btn-outline-secondary"
                                                onclick="togglePassword('confirmPassword')">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>

                                    <div id="matchMsg" class="form-text"></div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle me-1"></i>Đổi mật khẩu
                                    </button>
                                    <a href="${pageContext.request.contextPath}/member/profile"
                                       class="btn btn-outline-secondary">Quay lại</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-info-circle me-2"></i>Lưu ý
                            </h6>
                            <ul class="small text-muted mb-0 ps-3">
                                <li>Mật khẩu mới tối thiểu 6 ký tự.</li>
                                <li>Sau khi đổi, bạn sẽ được đăng xuất và cần đăng nhập lại.</li>
                                <li>Không chia sẻ mật khẩu với người khác.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        const icon = event.currentTarget.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }

    function checkMatch() {
        const newPwd     = document.getElementById('newPassword').value;
        const confirmPwd = document.getElementById('confirmPassword').value;
        const msg        = document.getElementById('matchMsg');

        if (confirmPwd === '') {
            msg.textContent = '';
            return;
        }
        if (newPwd === confirmPwd) {
            msg.textContent = '✓ Mật khẩu khớp';
            msg.className   = 'form-text text-success';
        } else {
            msg.textContent = '✗ Mật khẩu không khớp';
            msg.className   = 'form-text text-danger';
        }
    }
</script>
</body>
</html>