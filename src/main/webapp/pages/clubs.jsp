<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CODEGYM - Câu Lạc Bộ</title>
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <!-- Style cho Header và Footer -->
        <link href="${pageContext.request.contextPath}/css/style.css?v=2" rel="stylesheet">
        <!-- Style cho định dạng thân trang Clubs -->
        <link href="../css/clubs.css?v=2" rel="stylesheet">
    </head>

    <body>
        <!-- Header Component -->
        <jsp:include page="../components/header.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Section -->
            <section class="hero">
                <div class="container-inner">
                    <h1 class="hero-title">CÂU LẠC BỘ </h1>
                    <p class="hero-description">
                        Khám phá hệ thống phòng tập CODEGYM hiện đại, đa dạng.
                    </p>

                    <!-- Clubs Selection -->
                    <div class="clubs-section">
                        <div class="club-featured">
                            <div class="club-featured-info">
                                <h3 class="club-name">CODEGYM HÀ ĐÔNG</h3>
                                <div class="club-info-details">
                                    <p class="club-address">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" text-algin="left">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                            <circle cx="12" cy="10" r="3"></circle>
                                        </svg>
                                        Tòa nhà Ellipse - 112 Trần Phú, Hà Đông
                                    </p>
                                    <p class="club-phone">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path
                                                d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z">
                                            </path>
                                        </svg>
                                        0987 523 311
                                    </p>
                                </div>
                            </div>
                            <div class="club-featured-image">
                                <img src="../images/HÀ ĐÔNG.jpg" alt="CODEGYM HÀ ĐÔNG">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Registration Section -->
            <section class="registration">
                <div class="registration-container">
                    <h2 class="registration-title">ĐĂNG KÝ THAM GIA CÂU LẠC BỘ</h2>
                    <form class="registration-form" id="clubForm">
                        <div class="form-group">
                            <label for="fullname">Họ và tên</label>
                            <input type="text" id="fullname" name="fullname" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" required>
                        </div>
                        <div class="form-group">
                            <label for="time">Giờ nào tôi có thể gọi cho bạn</label>
                            <input type="time" id="time" name="time" required>
                        </div>
                        <div class="form-group">
                            <label for="gender">Giới tính</label>
                            <select id="gender" name="gender" required>
                                <option value="">Chọn giới tính</option>
                                <option value="male">Nam</option>
                                <option value="female">Nữ</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="club">Câu lạc bộ bạn muốn tham gia</label>
                            <select id="club" name="club" required>
                                <option value="ha-dong" selected>CODEGYM HÀ ĐÔNG</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="address">Địa chỉ</label>
                            <textarea id="address" name="address" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn-submit">ĐĂNG KÝ NGAY</button>
                    </form>
                </div>
            </section>


        </main>

        <!-- Footer Component -->
        <jsp:include page="../components/footer.jsp" />

        <script>
            document.getElementById("clubForm").addEventListener("submit", function (event) {
                event.preventDefault(); // Ngăn form tải lại trang

                // Tìm thẻ form
                const formObj = document.getElementById("clubForm");

                // Lấy container chứa form
                const container = formObj.parentElement;

                // Gửi dữ liệu đi (tuỳ chọn - hiện tại hệ thống giả lập thành công)
                // ...

                // Thay thế nội dung bằng thông báo thành công
                container.innerHTML = `
                <h2 class="registration-title" style="margin-bottom: 30px;">ĐĂNG KÝ THAM GIA CÂU LẠC BỘ</h2>
                <div style="text-align: center; padding: 60px 20px; background-color: #fff; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 15px rgba(0,0,0,0.05); animation: fadeIn 0.5s;">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#28a745" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <h3 style="color: #333; font-size: 24px; margin-bottom: 12px; font-weight: 700;">Đăng ký thành công!</h3>
                    <p style="color: #555; font-size: 18px; line-height: 1.5;">Chúng tôi sẽ liên hệ với bạn sớm nhất.</p>
                </div>
            `;
            });
        </script>
    </body>

    </html>