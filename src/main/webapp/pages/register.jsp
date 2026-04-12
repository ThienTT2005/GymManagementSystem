<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeGym - Đăng ký tập thử</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/register.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <jsp:include page="../components/header.jsp" />

        <!-- Registration Section -->
        <section class="registration-section">
            <div class="registration-inner">
            <div class="form-container">
                <h1 class="form-title">TẬP THỬ MIỄN PHÍ<br>TẠI PHÒNG TẬP CAO CẤP</h1>
                <div class="form-box">
                    <p class="form-description">
                        Đăng ký nhận tư vấn gói tập thử miễn phí hoặc tham gia câu lạc bộ để cảm nhận chất lượng dịch vụ ngay hôm nay
                    </p>
                    <form id="registerForm">
                        <div class="form-group">
                            <label for="name">Họ và tên:</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại:</label>
                            <input type="tel" id="phone" name="phone" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email (nếu có):</label>
                            <input type="email" id="email" name="email">
                        </div>
                        <button type="submit" class="submit-btn" style="display: block; margin: 0 auto; margin-top: 30px;">ĐĂNG KÝ NGAY</button>
                    </form>
                    <div id="registerMessage" style="display:none; color: green; font-size: 18px; font-weight: bold; text-align: center; margin-top: 30px;">
                        Đã nhận thông tin
                    </div>
                </div>
            </div>

            <div class="images-gallery">
                <div class="gallery-bg"></div>
                <img src="../images/bums-tums-8.png" alt="Gym" class="gallery-img gallery-img-1">
                <img src="../images/banner-dang-ky-tap-8.png" alt="Gym" class="gallery-img gallery-img-2">
                <img src="../images/banner-tin-tuc-8.png" alt="Gym" class="gallery-img gallery-img-3">
            </div>
            </div>
        </section>

        <!-- Introduction Section -->
        <section class="intro-section">
            <div class="intro-content">
                <h2 class="section-title">ĐẾN CODEGY, TẬP LUYỆN<br>ĐA DẠNG BỘ MÔN</h2>
                <div class="divider"></div>
                <p style="font-size: 30px; margin-top: 40px;">Lorem ipsum dolor sit amet consectetur adipisicing elit. Aspernatur exercitationem labore, ipsum cumque distinctio aliquam aperiam eaque quis. Vero sunt animi ipsum molestiae, ratione deleniti nesciunt debitis error aspernatur autem.</p>
            </div>
            <div class="intro-images">
                <div class="intro-img-wrapper">
                    <img src="../images/banner-de-xuat-8.png" alt="Gym facility" class="intro-img">
                    <img src="../images/banner-de-xuat-8.png" alt="Gym facility" class="intro-img">
                </div>
                <p style="font-size: 24px; color: black; margin-top: 10px;">Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime veritatis, hic, illo, totam labore quos dolor ratione optio error minima sint quisquam quae consectetur ea nam doloribus possimus nulla commodi.</p>
            </div>
        </section>

        <!-- Location Section -->
        <section class="location-section">
            <div class="location-grid">
                <div class="location-card">
                    <img src="../images/LB.jpg" alt="Long Biên">
                    <div class="location-overlay">
                        <p class="location-name">LONG BIÊN</p>
                    </div>
                </div>
                <div class="location-card">
                    <img src="../images/HÀ ĐÔNG.jpg" alt="Hà Đông">
                    <div class="location-overlay">
                        <p class="location-name">HÀ ĐÔNG</p>
                    </div>
                </div>
            </div>
            <div class="location-content">
                <h2 class="section-title">ĐẾN CODEGY, TẬP LUYỆN<br>ĐA DẠNG BỘ MÔN</h2>
                <div class="divider"></div>
                <p style="font-size: 30px; margin-top: 40px;">TEXT</p>
            </div>
        </section>

        <!-- Footer -->
        <jsp:include page="../components/footer.jsp" />
    </div>
    <script>
        const regForm = document.getElementById("registerForm");
        if (regForm) {
            regForm.addEventListener("submit", async function (e) {
                e.preventDefault();
                
                const fullName = this.querySelector('input[name="name"]').value;
                const phone = this.querySelector('input[name="phone"]').value;
                const email = this.querySelector('input[name="email"]').value;

                try {
                    const response = await fetch('/api/trial-requests', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            fullName: fullName,
                            phone: phone,
                            email: email,
                            note: "Đăng ký từ trang cá nhân (Register) không cung cấp ngày và ghi chú chuyên sâu."
                        })
                    });

                    if (response.ok) {
                        this.style.display = "none";
                        document.getElementById("registerMessage").style.display = "block";
                    } else {
                        alert("Có lỗi xảy ra, vui lòng thử lại sau!");
                    }
                } catch (error) {
                    console.error('Error saving data:', error);
                    alert("Có lỗi xảy ra, vui lòng thử lại sau!");
                }
            });
        }

        // Form Validation Logic
        document.addEventListener("DOMContentLoaded", function () {
            // Validate Tên: Chỉ được nhập chữ và khoảng trắng (bao gồm cả tiếng Việt)
            const nameInputs = document.querySelectorAll('input[name="name"], input[name="fullName"], input[name="fullname"]');
            nameInputs.forEach(input => {
                input.addEventListener('input', function () {
                    if (/[^a-zA-Z\u00C0-\u1EF9\s]/.test(this.value)) {
                        showError(this, 'Tên chỉ được chứa chữ cái!');
                        this.value = this.value.replace(/[^a-zA-Z\u00C0-\u1EF9\s]/g, ''); 
                    } else {
                        removeError(this);
                    }
                });
            });

            // Validate SĐT: Bắt đầu bằng 0 và tối đa 10 số
            const phoneInputs = document.querySelectorAll('input[name="phone"]');
            phoneInputs.forEach(input => {
                input.addEventListener('input', function () {
                    let val = this.value.replace(/[^\d]/g, '');
                    if (val.length > 0 && val[0] !== '0') {
                        val = '0' + val.substring(1);
                        showError(this, 'Số điện thoại phải bắt đầu bằng 0!');
                    }
                    if (val.length > 10) {
                        val = val.substring(0, 10);
                    }
                    this.value = val;
                    if (val.length > 0 && val.length < 10) {
                        showError(this, 'Số điện thoại phải đủ 10 chữ số!');
                    } else if (val.length === 10) {
                        removeError(this);
                    } else if (val.length === 0) {
                        removeError(this);
                    }
                });
            });

            // Validate Tuổi, Chiều cao, Cân nặng: Chỉ được nhập số
            const numInputs = document.querySelectorAll('input[name="age"], input[name="height"], input[name="weight"]');
            numInputs.forEach(input => {
                input.addEventListener('input', function () {
                    if (/[^\d.]/.test(this.value)) {
                        showError(this, 'Trường này chỉ được nhập số!');
                        this.value = this.value.replace(/[^\d.]/g, ''); 
                    } else {
                        removeError(this);
                    }
                });
            });

            // Validate Email (không có khoảng trắng, tiếng Việt)
            const emailInputs = document.querySelectorAll('input[name="email"], input[type="email"]');
            emailInputs.forEach(input => {
                input.addEventListener('input', function () {
                    if (/[\s\u00C0-\u017F]/.test(this.value)) {
                        showError(this, 'Email không được chứa khoảng trắng hoặc tiếng Việt!');
                        this.value = this.value.replace(/[\s\u00C0-\u017F]/g, '');
                    } else {
                        removeError(this);
                    }
                });
            });

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
                clearTimeout(input.errorTimeout);
                input.errorTimeout = setTimeout(() => removeError(input), 3000);
            }

            function removeError(input) {
                let errorElement = input.nextElementSibling;
                if (errorElement && errorElement.classList.contains('input-error-msg')) {
                    errorElement.remove();
                }
            }
        });
    </script>
</body>
</html>
