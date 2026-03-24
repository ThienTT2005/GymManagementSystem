<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CODEGYM - Câu Lạc Bộ</title>
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Style cho Header và Footer -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <!-- Style cho định dạng thân trang Clubs -->
    <link href="../css/clubs.css" rel="stylesheet">
</head>
<body>
    <!-- Header Component -->
    <jsp:include page="../components/header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero">
            <div class="container-inner">
                <h1 class="hero-title">CÂU LẠC BỘ Ở GẦN BẠN</h1>
                <p class="hero-description">
                    Khám phá hệ thống phòng tập CODEGYM hiện đại, đa dạng, đáp ứng mọi nhu cầu tập luyện của bạn, dù bạn ở bất kỳ đâu tại Hà Nội.
                </p>

                <!-- Clubs Selection -->
                <div class="clubs-section">
                    <label class="clubs-label">Chọn quận/ huyện:</label>
                    <div class="clubs-grid">
                        <div class="club-card">
                            <h3 class="club-name">CODEGYM LONG BIÊN</h3>
                            <p class="club-address">Tầng 2 tòa nhà One, Ngõ 298 Ngọc Lâm, Long Biên</p>
                            <p class="club-phone">0986 452 211</p>
                        </div>
                        <div class="club-card">
                            <h3 class="club-name">CODEGYM HÀ ĐÔNG</h3>
                            <p class="club-address">Số 112 Trần Phú, Mộ Lao, Hà Đông</p>
                            <p class="club-phone">0987 523 311</p>
                        </div>
                        <div class="club-card">
                            <h3 class="club-name">CODEGYM VÕ THỊ SÁU</h3>
                            <p class="club-address">Toà Imperial Plaza 360 Giải Phóng, Thanh Xuân</p>
                            <p class="club-phone">0987 503 311</p>
                        </div>
                        <div class="club-card">
                            <h3 class="club-name">CODEGYM GIẢI PHÓNG</h3>
                            <p class="club-address">Số 101 Võ Thị Sáu, Thanh Nhàn, Hai Bà Trưng</p>
                            <p class="club-phone">0987 562 211</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Registration Section -->
        <section class="registration">
            <div class="registration-container">
                <h2 class="registration-title">ĐĂNG KÝ THAM GIA CÂU LẠC BỘ</h2>
                <form class="registration-form" action="register" method="POST">
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
                            <option value="">Chọn câu lạc bộ</option>
                            <option value="long-bien">CODEGYM LONG BIÊN</option>
                            <option value="ha-dong">CODEGYM HÀ ĐÔNG</option>
                            <option value="vo-thi-sau">CODEGYM VÕ THỊ SÁU</option>
                            <option value="giai-phong">CODEGYM GIẢI PHÓNG</option>
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

        <!-- Information Section -->
        <section class="information">
            <div class="container-inner">
                <h2 class="info-title">THÔNG TIN LIÊN HỆ</h2>
                
                <div class="contact-grid">
                    <div class="contact-item">
                        <h3>Liên Hệ</h3>
                        <p>0355151178</p>
                    </div>
                    <div class="contact-item">
                        <h3>Dịch Vụ</h3>
                        <p>Xem danh sách dịch vụ</p>
                    </div>
                    <div class="contact-item">
                        <h3>Chính sách giá</h3>
                        <p>Xem bảng giá</p>
                    </div>
                    <div class="contact-item">
                        <h3>Chính sách bảo mật</h3>
                        <p>Xem chi tiết</p>
                    </div>
                </div>

                <div class="schedule">
                    <h3>Giờ Hoạt Động</h3>
                    <p>
                        <strong>Áp dụng tại 3 cơ sở Võ Thị Sáu, Hà Đông, Giải Phóng</strong><br>
                        Thứ Hai - Thứ Sáu: 5:30 đến 21:30<br>
                        Thứ Bảy - Chủ Nhật: 5:30 đến 20:30
                    </p>
                    <p>
                        <strong>Áp dụng tại cơ sở Long Biên</strong><br>
                        Thứ Hai - Thứ Sáu: 5:30 đến 21:00<br>
                        Thứ Bảy - Chủ Nhật: 5:30 đến 20:00
                    </p>
                </div>

                <div class="addresses">
                    <h3>Địa Chỉ Chi Nhánh</h3>
                    <div class="address-list">
                        <div class="address-item">
                            <strong>CODEGYM VÕ THỊ SÁU:</strong><br>Số 101 Võ Thị Sáu, Thanh Nhàn, Hai Bà Trưng, Hà Nội<br>
                            <strong>ĐT:</strong> 0987 562 211
                        </div>
                        <div class="address-item">
                            <strong>CODEGYM HÀ ĐÔNG:</strong><br>Toà nhà Ellipse số 112 Trần Phú, Mộ Lao, Hà Đông<br>
                            <strong>ĐT:</strong> 0987 523 311
                        </div>
                        <div class="address-item">
                            <strong>CODEGYM GIẢI PHÓNG:</strong><br>Tầng B1, toà Imperial Plaza 360 Giải Phóng, Thanh Xuân, Hà Nội<br>
                            <strong>ĐT:</strong> 0987 503 311
                        </div>
                        <div class="address-item">
                            <strong>CODEGYM LONG BIÊN:</strong><br>Tầng 2, Chung cư One 18, Ngõ 298 Ngọc Lâm, Long Biên, Hà Nội<br>
                            <strong>ĐT:</strong> 0986 452 211
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer Component -->
    <jsp:include page="../components/footer.jsp" />
</body>
</html>