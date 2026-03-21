<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeGym - Đăng ký tập thử</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: white;
        }

        .container {
            width: 100%;
            position: relative;
            background: white;
        }

        /* Registration Section */
        .registration-section {
            background: #8d1317;
            width: 100%;
        }

        .registration-inner {
            padding: 40px 75px;
            display: flex;
            justify-content: space-between;
            gap: 50px;
            max-width: 1280px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
        }

        .form-container {
            flex: 1;
            max-width: 456px;
        }

        .form-title {
            color: white;
            font-size: 30px;
            font-weight: bold;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .form-box {
            background: white;
            border-radius: 10px;
            padding: 30px;
        }

        .form-description {
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 30px;
            line-height: 1.4;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #D28080;
            border-radius: 8px;
            font-size: 16px;
        }

        .submit-btn {
            background: #8d131c;
            color: white;
            padding: 14px 40px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            display: block;
            margin: 30px auto 0;
        }

        .submit-btn:hover {
            background: #6d0f15;
        }

        .images-gallery {
            flex: 1;
            position: relative;
            max-width: 614px;
            min-height: 500px;
        }

        .gallery-bg {
            position: absolute;
            width: 400px;
            height: 400px;
            background: #d6a7a7;
            border-radius: 20px;
            top: 60px;
            left: 100px;
            z-index: 0;
        }

        .gallery-img {
            border-radius: 20px;
            position: absolute;
            object-fit: cover;
            z-index: 1;
        }

        .gallery-img-1 {
            width: 250px;
            height: 320px;
            left: 20px;
            top: 20px;
        }

        .gallery-img-2 {
            width: 180px;
            height: 280px;
            left: 290px;
            top: 30px;
        }

        .gallery-img-3 {
            width: 300px;
            height: 200px;
            left: 150px;
            top: 320px;
        }

        /* Introduction Section */
        .intro-section {
            padding: 60px;
            display: flex;
            justify-content: space-between;
            gap: 40px;
            max-width: 1194px;
            margin: 50px auto;
        }

        .intro-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .section-title {
            font-size: 30px;
            font-weight: bold;
            color: #1c1b1f;
            margin-bottom: 20px;
            line-height: 1.4;
        }

        .divider {
            width: 500px;
            height: 1px;
            background: #8D1317;
            margin: 20px 0;
            max-width: 100%;
        }

        .intro-images {
            background: #8d1317;
            border-radius: 30px;
            padding: 30px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .intro-img-wrapper {
            display: flex;
            justify-content: space-between;
            gap: 15px;
        }

        .intro-img {
            width: calc(50% - 7.5px);
            height: 200px;
            border-radius: 20px;
            object-fit: cover;
        }

        /* Location Section */
        .location-section {
            padding: 60px;
            max-width: 1194px;
            margin: 50px auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 50px;
        }

        .location-grid {
            display: flex;
            gap: 30px;
            flex: 1;
        }

        .location-card {
            position: relative;
            width: calc(50% - 15px);
            aspect-ratio: 1 / 1;
            border-radius: 20px;
            overflow: hidden;
        }

        .location-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .location-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(141, 19, 23, 0.8);
            padding: 15px;
            text-align: center;
        }

        .location-name {
            color: black;
            font-size: 30px;
            font-weight: bold;
        }

        .location-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: right;
        }

        .location-content .section-title {
            text-align: right;
            margin-bottom: 20px;
        }

        .location-content .divider {
            margin-left: auto;
            margin-right: 0;
            width: 500px;
            max-width: 100%;
        }

    </style>
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
            regForm.addEventListener("submit", function (e) {
                e.preventDefault();
                const formData = new FormData(this);
                fetch("${pageContext.request.contextPath}/pages/saveRegistration.jsp", {
                    method: "POST",
                    body: formData
                })
                    .then(res => res.text())
                    .then(data => {
                        if (data.trim() === "success") {
                            document.getElementById("registerForm").style.display = "none";
                            document.getElementById("registerMessage").style.display = "block";
                        } else {
                            alert("Có lỗi xảy ra, vui lòng thử lại sau!");
                        }
                    });
            });
        }
    </script>
</body>
</html>
