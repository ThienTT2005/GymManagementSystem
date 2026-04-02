<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PTIT Gym - Chính sách giá</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pricing.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="pricing-page">
    <!-- Banner -->
    <section class="pricing-banner">
        <img
                src="${pageContext.request.contextPath}/images/banner-pricing.png"
                alt="Chính sách giá"
                class="pricing-banner-image"
        >
        <h1 class="pricing-banner-title">CHÍNH SÁCH GIÁ</h1>
    </section>

    <!-- Bảng giá -->
    <section class="pricing-section">
        <div class="pricing-content">
            <div class="pricing-tabs">
                <button type="button" class="pricing-tab active">CLASSIC</button>
                <button type="button" class="pricing-tab">CLASSIC-PLUS</button>
                <button type="button" class="pricing-tab">PREMIUM</button>
                <button type="button" class="pricing-tab">SIGNATURE</button>
            </div>

            <div class="pricing-main">
                <div class="pricing-duration">
                    <ul class="duration-list">
                        <li class="active">24 THÁNG</li>
                        <li>12 THÁNG</li>
                        <li>6 THÁNG</li>
                        <li>3 THÁNG</li>
                        <li>1 THÁNG</li>
                    </ul>
                </div>

                <div class="pricing-divider"></div>

                <div class="pricing-info">
                    <ul>
                        <li>
                            <span>Thời gian tập luyện:</span>
                            <strong>24 tháng</strong>
                        </li>
                        <li>
                            <span>Tổng chi phí:</span>
                            <strong>15,370,000 VNĐ</strong>
                        </li>
                        <li>
                            <span>Chi phí / tháng:</span>
                            <strong>640,417 VNĐ</strong>
                        </li>
                        <li>
                            <span>Chi phí / ngày:</span>
                            <strong>21,347 VNĐ</strong>
                        </li>
                    </ul>
                </div>

                <div class="pricing-figure">
                    <img
                            src="${pageContext.request.contextPath}/images/pricing-man.png"
                            alt="Huấn luyện"
                    >
                </div>
            </div>
        </div>
    </section>

    <!-- Form đăng ký -->
    <section class="register-section">
        <div class="register-box">
            <h2 class="register-title">ĐĂNG KÝ THAM GIA CÂU LẠC BỘ</h2>

            <form class="register-form" id="registerForm">
                <div class="form-grid">
                    <input type="text" name="fullName" placeholder="Họ và tên" required>
                    <input type="tel" name="phone" placeholder="Số điện thoại" required>

                    <select name="gender" required>
                        <option value="">Giới tính</option>
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>

                    <input type="text" name="callTime" placeholder="Giờ nào tôi có thể gọi cho bạn" required>

                    <select name="club" required>
                        <option value="">Câu lạc bộ bạn muốn tham gia</option>
                        <option value="classic">Classic</option>
                        <option value="classic-plus">Classic Plus</option>
                        <option value="premium">Premium</option>
                        <option value="signature">Signature</option>
                    </select>

                    <input type="text" name="address" placeholder="Địa chỉ" required>
                </div>

                <button type="submit" class="register-btn">ĐĂNG KÝ NGAY</button>
                <p id="successMessage" class="success-message">Chúng tôi sẽ liên hệ với bạn sớm nhất</p>
            </form>
        </div>
    </section>
</main>

<jsp:include page="/components/footer.jsp" />

<script>
    const registerForm = document.getElementById("registerForm");
    const successMessage = document.getElementById("successMessage");

    registerForm.addEventListener("submit", function (e) {
        e.preventDefault();

        if (registerForm.checkValidity()) {
            successMessage.style.display = "block";
            registerForm.reset();
        } else {
            registerForm.reportValidity();
        }
    });
</script>

</body>
</html>