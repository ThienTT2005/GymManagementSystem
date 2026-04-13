<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

    <jsp:include page="/components/header.jsp"/>

    <section class="registration-section">
        <div class="registration-inner">

            <!-- FORM -->
            <div class="form-container">
                <h1 class="form-title">
                    TẬP THỬ MIỄN PHÍ<br>TẠI PHÒNG TẬP CAO CẤP
                </h1>

                <div class="form-box">

                    <p class="form-description">
                        Đăng ký nhận tư vấn gói tập thử miễn phí hoặc tham gia câu lạc bộ để cảm nhận chất lượng dịch vụ ngay hôm nay
                    </p>

                    <form id="registerForm" novalidate>

                        <div class="form-group">
                            <label>Họ và tên:</label>
                            <input type="text" name="name" required>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại:</label>
                            <input type="tel" name="phone" required inputmode="numeric">
                        </div>

                        <div class="form-group">
                            <label>Email (nếu có):</label>
                            <input type="email" name="email">
                        </div>

                        <div class="form-group">
                            <label>Ngày đăng ký tập thử:</label>
                            <input type="date" name="preferredDate" required>
                        </div>

                        <button type="submit" class="submit-btn">
                            ĐĂNG KÝ NGAY
                        </button>

                    </form>

                    <div id="registerMessage"
                         style="display:none; color: green; font-size: 18px; font-weight: bold; text-align: center; margin-top: 30px;">
                        Đã nhận thông tin
                    </div>

                </div>
            </div>

            <!-- IMAGE -->
            <div class="images-gallery">
                <div class="gallery-bg"></div>

                <img src="${pageContext.request.contextPath}/images/bums-tums-8.png"
                     class="gallery-img gallery-img-1">

                <img src="${pageContext.request.contextPath}/images/banner-dang-ky-tap-8.png"
                     class="gallery-img gallery-img-2">

                <img src="${pageContext.request.contextPath}/images/banner-tin-tuc-8.png"
                     class="gallery-img gallery-img-3">
            </div>

        </div>
    </section>

    <jsp:include page="/components/footer.jsp"/>

</div>

<script>
    (function () {

        const ctxPath = "${pageContext.request.contextPath}";
        const form = document.getElementById("registerForm");

        if (!form) return;

        const name = form.querySelector('[name="name"]');
        const phone = form.querySelector('[name="phone"]');
        const email = form.querySelector('[name="email"]');
        const date = form.querySelector('[name="preferredDate"]');

        function normalize(v) {
            return v.trim().replace(/\s+/g, " ");
        }

        function validName(v) {
            return /^[\p{L}\s.]+$/u.test(normalize(v));
        }

        function validPhone(v) {
            return /^0\d{9}$/.test(v.trim());
        }

        function error(el, msg) {
            let span = el.nextElementSibling;

            if (!span || !span.classList.contains('err')) {
                span = document.createElement('span');
                span.className = 'err';
                span.style.color = 'red';
                span.style.fontSize = '12px';
                el.after(span);
            }

            span.innerText = msg;
        }

        function clear(el) {
            if (el.nextElementSibling && el.nextElementSibling.classList.contains('err')) {
                el.nextElementSibling.remove();
            }
        }

        function validate() {

            let ok = true;

            if (!name.value.trim() || !validName(name.value)) {
                error(name, "Tên không hợp lệ");
                ok = false;
            } else clear(name);

            if (!validPhone(phone.value)) {
                error(phone, "SĐT không hợp lệ");
                ok = false;
            } else clear(phone);

            if (email.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
                error(email, "Email sai định dạng");
                ok = false;
            } else clear(email);

            if (!date.value) {
                error(date, "Chọn ngày");
                ok = false;
            } else clear(date);

            return ok;
        }

        form.addEventListener("submit", async function (e) {
            e.preventDefault();

            if (!validate()) return;

            try {
                const res = await fetch(ctxPath + '/api/trial-requests', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        fullName: normalize(name.value),
                        phone: phone.value.trim(),
                        email: email.value.trim(),
                        note: "Đăng ký từ trang register",
                        preferredDate: date.value
                    })
                });

                if (res.ok) {
                    form.style.display = "none";
                    document.getElementById("registerMessage").style.display = "block";
                } else {
                    alert("Lỗi server");
                }

            } catch (e) {
                alert("Lỗi kết nối");
            }
        });

    })();
</script>

</body>
</html>