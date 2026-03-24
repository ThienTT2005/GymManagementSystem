<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | Gym Member</title>
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

            <h2 class="mb-4"><i class="bi bi-credit-card me-2"></i>Thanh toán</h2>

            <c:if test="${param.new == '1'}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle me-2"></i>
                    Đăng ký gói tập thành công! Vui lòng hoàn tất thanh toán bên dưới.
                </div>
            </c:if>

            <div class="row g-4">
                <%-- Thông tin chuyển khoản --%>
                <div class="col-md-5">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white border-0 pt-3">
                            <h5 class="mb-0"><i class="bi bi-bank me-2"></i>Thông tin thanh toán</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3 p-3 bg-light rounded">
                                <p class="mb-1"><strong>Ngân hàng:</strong> Vietcombank</p>
                                <p class="mb-1"><strong>Số TK:</strong> 1234567890</p>
                                <p class="mb-1"><strong>Chủ TK:</strong> CÔNG TY GYM PRO</p>
                                <p class="mb-0"><strong>Nội dung CK:</strong>
                                    <code>GYMMEMBER${membership.membershipId}</code>
                                </p>
                            </div>
                            <table class="table table-borderless small">
                                <tr>
                                    <td class="text-muted">Gói tập:</td>
                                    <td class="fw-bold">${pkg.packageName}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Thời hạn:</td>
                                    <td>${pkg.durationMonth} tháng</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Số tiền:</td>
                                    <td class="fw-bold text-primary fs-5">
                                        <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true"/>đ
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Ngày đăng ký:</td>
                                    <td>${membership.startDate}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- Upload minh chứng --%>
                <div class="col-md-7">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white border-0 pt-3">
                            <h5 class="mb-0"><i class="bi bi-upload me-2"></i>Upload minh chứng thanh toán</h5>
                        </div>
                        <div class="card-body">
                            <p class="text-muted small mb-3">
                                Sau khi chuyển khoản, vui lòng chụp màn hình biên lai và upload lên đây.
                                Admin sẽ xác nhận trong vòng 24h.
                            </p>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/member/upload-payment"
                                  enctype="multipart/form-data">
                                <input type="hidden" name="membershipId" value="${membership.membershipId}">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Chọn ảnh biên lai</label>
                                    <input type="file" name="proofImage" class="form-control"
                                           accept="image/jpeg,image/png,image/jpg" required
                                           onchange="previewImage(this)">
                                    <div class="form-text">Chấp nhận: JPG, PNG. Tối đa 5MB.</div>
                                </div>

                                <div id="imagePreview" class="mb-3 d-none">
                                    <img id="previewImg" src="#" alt="Preview"
                                         class="img-thumbnail" style="max-height:200px;">
                                </div>

                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-cloud-upload me-2"></i>Gửi minh chứng
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">
                            <h6 class="fw-semibold"><i class="bi bi-question-circle me-2"></i>Quy trình xử lý</h6>
                            <ol class="small text-muted ps-3 mb-0">
                                <li>Bạn đăng ký gói tập</li>
                                <li>Chuyển khoản theo thông tin trên</li>
                                <li>Upload ảnh biên lai chuyển khoản</li>
                                <li>Admin xem xét và duyệt trong 24h</li>
                                <li>Gói tập được kích hoạt sau khi duyệt</li>
                            </ol>
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
        const preview = document.getElementById('imagePreview');
        const img = document.getElementById('previewImg');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                img.src = e.target.result;
                preview.classList.remove('d-none');
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>
