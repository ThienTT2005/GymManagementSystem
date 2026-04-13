<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeGym - Đăng ký tập thử</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>
<div class="container">
    <jsp:include page="/components/header.jsp" />

    <section class="registration-section">
        <div class="registration-inner">
            <div class="form-container">
                <h1 class="form-title">TẬP THỬ MIỄN PHÍ<br>TẠI PHÒNG TẬP CAO CẤP</h1>
                <div class="form-box">
                    <p class="form-description">
                        Đăng ký nhận tư vấn gói tập thử miễn phí hoặc tham gia câu lạc bộ để cảm nhận chất lượng dịch vụ ngay hôm nay
                    </p>

                    <form id="registerForm" novalidate>
                        <div class="form-group">
                            <label for="name">Họ và tên:</label>
                            <input type="text" id="name" name="name" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại:</label>
                            <input type="tel" id="phone" name="phone" required inputmode="numeric">
                        </div>

                        <div class="form-group">
                            <label for="email">Email (nếu có):</label>
                            <input type="email" id="email" name="email">
                        </div>

                        <div class="form-group">
                            <label for="preferredDate">Ngày đăng ký tập thử:</label>
                            <input type="date" id="preferredDate" name="preferredDate" required>
                        </div>

                        <button type="submit" class="submit-btn" style="display: block; margin: 0 auto; margin-top: 30px;">
                            ĐĂNG KÝ NGAY
                        </button>
                    </form>

                    <div id="registerMessage" style="display:none; color: green; font-size: 18px; font-weight: bold; text-align: center; margin-top: 30px;">
                        Đã nhận thông tin
                    </div>
                </div>
            </div>

            <div class="images-gallery">
                <div class="gallery-bg"></div>
                <img src="${pageContext.request.contextPath}/images/bums-tums-8.png" alt="Gym" class="gallery-img gallery-img-1">
                <img src="${pageContext.request.contextPath}/images/banner-dang-ky-tap-8.png" alt="Gym" class="gallery-img gallery-img-2">
                <img src="${pageContext.request.contextPath}/images/banner-tin-tuc-8.png" alt="Gym" class="gallery-img gallery-img-3">
            </div>
        </div>
    </section>

    <section class="intro-section">
        <div class="intro-content">
            <h2 class="section-title">ĐẾN CODEGYM, TẬP LUYỆN<br>ĐA DẠNG BỘ MÔN</h2>
            <div class="divider"></div>
            <p style="font-size: 30px; margin-top: 40px;">
                Tại CODEGYM, chúng tôi mang đến hệ thống tập luyện đẳng cấp với các bộ môn từ nhảy hiện đại, võ thuật tự vệ đến các bài tập cân bằng thân tâm. Dù mục tiêu của bạn là giảm cân, tăng cơ hay giải tỏa căng thẳng, chúng tôi luôn có lộ trình phù hợp dành riêng cho bạn.
            </p>
        </div>

        <div class="intro-images">
            <div class="intro-img-wrapper">
                <img src="${pageContext.request.contextPath}/images/banner-de-xuat-8.png" alt="Gym facility" class="intro-img">
                <img src="${pageContext.request.contextPath}/images/banner-de-xuat-8.png" alt="Gym facility" class="intro-img">
            </div>
            <p style="font-size: 24px; color: black; margin-top: 10px;">
                Máy móc nhập khẩu 100%, chuẩn quốc tế, hỗ trợ tối đa lộ trình bứt phá vóc dáng.
            </p>
        </div>
    </section>

    <section class="location-section">
        <div class="location-grid">
            <div class="location-card">
                <img src="${pageContext.request.contextPath}/images/HÀ ĐÔNG.jpg" alt="Hà Đông">
                <div class="location-overlay">
                    <p class="location-name">HÀ ĐÔNG</p>
                </div>
            </div>
        </div>

        <div class="location-content">
            <h2 class="section-title">HỆ THỐNG PHÒNG TẬP<br>HIỆN ĐẠI & ĐẲNG CẤP</h2>
            <div class="divider"></div>
            <p style="font-size: 30px; margin-top: 40px;">
                CODEGYM tự hào sở hữu không gian tập luyện với thiết kế hiện đại, tối ưu hóa diện tích và ánh sáng.
                Mỗi khu vực được phân chia khoa học, giúp bạn luôn tìm thấy cảm hứng và sự tập trung cao nhất
                trong từng bài tập.
            </p>
        </div>
    </section>

    <jsp:include page="/components/footer.jsp" />
</div>

<script>
    (function () {
        const ctxPath = "${pageContext.request.contextPath}";
        const regForm = document.getElementById("registerForm");
        if (!regForm) return;

        const nameInput = regForm.querySelector('input[name="name"]');
        const phoneInput = regForm.querySelector('input[name="phone"]');
        const emailInput = regForm.querySelector('input[name="email"]');
        const preferredDateInput = regForm.querySelector('input[name="preferredDate"]');

        function normalizeSpaces(value) {
            return value.trim().replace(/\s+/g, " ");
        }

        function isValidFullName(value) {
            const normalized = normalizeSpaces(value);
            return /^[\p{L}\s.]+$/u.test(normalized) && normalized.length >= 2;
        }

        function isValidPhone(value) {
            const normalized = value.trim().replace(/\s+/g, "");
            return /^0\d{9}$/.test(normalized);
        }

        function showError(input, message) {
            let errorElement = input.nextElementSibling;
            if (!errorElement || !errorElement.classList.contains('input-error-msg')) {
                errorElement = document.createElement('span');
                errorElement.classList.add('input-error-msg');
                errorElement.style.color = 'red';
                errorElement.style.fontSize = '12px';
                errorElement.style.display = 'block';
                errorElement.style.marginTop = '5px';
                input.parentNode.insertBefore(errorElement, input.nextSibling);
            }
            errorElement.innerText = message;
        }

        function removeError(input) {
            const errorElement = input.nextElementSibling;
            if (errorElement && errorElement.classList.contains('input-error-msg')) {
                errorElement.remove();
            }
        }

        function validateName() {
            const value = nameInput.value;
            if (!value.trim()) {
                showError(nameInput, 'Vui lòng nhập họ và tên');
                return false;
            }
            if (!isValidFullName(value)) {
                showError(nameInput, 'Họ tên chỉ bao gồm chữ cái, khoảng trắng hoặc dấu chấm');
                return false;
            }
            removeError(nameInput);
            return true;
        }

        function validatePhone() {
            const value = phoneInput.value;
            if (!value.trim()) {
                showError(phoneInput, 'Vui lòng nhập số điện thoại');
                return false;
            }
            if (!isValidPhone(value)) {
                showError(phoneInput, 'Số điện thoại phải gồm đúng 10 số và bắt đầu bằng số 0');
                return false;
            }
            removeError(phoneInput);
            return true;
        }

        function validateEmail() {
            const value = emailInput.value.trim();
            if (!value) {
                removeError(emailInput);
                return true;
            }
            const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
            if (!ok) {
                showError(emailInput, 'Email không đúng định dạng');
                return false;
            }
            removeError(emailInput);
            return true;
        }

        function validatePreferredDate() {
            const value = preferredDateInput.value;
            if (!value) {
                showError(preferredDateInput, 'Vui lòng chọn ngày đăng ký tập thử');
                return false;
            }

            const selectedDate = new Date(value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (selectedDate < today) {
                showError(preferredDateInput, 'Ngày đăng ký tập thử phải từ hôm nay trở đi');
                return false;
            }

            removeError(preferredDateInput);
            return true;
        }

        nameInput.addEventListener('input', validateName);
        phoneInput.addEventListener('input', function () {
            this.value = this.value.replace(/[^\d\s]/g, '');
            validatePhone();
        });
        emailInput.addEventListener('input', validateEmail);
        preferredDateInput.addEventListener('change', validatePreferredDate);

        regForm.addEventListener("submit", async function (e) {
            e.preventDefault();

            const valid =
                validateName() &&
                validatePhone() &&
                validateEmail() &&
                validatePreferredDate();

            if (!valid) return;

            const fullName = normalizeSpaces(nameInput.value);
            const phone = phoneInput.value.trim().replace(/\s+/g, '');
            const email = emailInput.value.trim();
            const preferredDate = preferredDateInput.value;

            try {
                const response = await fetch(ctxPath + '/api/trial-requests', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        fullName: fullName,
                        phone: phone,
                        email: email,
                        note: "Đăng ký từ trang đăng ký tập thử",
                        preferredDate: preferredDate
                    })
                });

                const responseText = await response.text();

                if (response.ok) {
                    this.style.display = "none";
                    document.getElementById("registerMessage").style.display = "block";
                } else {
                    alert(responseText || "Có lỗi xảy ra, vui lòng thử lại sau!");
                }
            } catch (error) {
                console.error('Error saving data:', error);
                alert("Có lỗi xảy ra, vui lòng thử lại sau!");
            }
        });
    })();
</script>
</body>
</html>