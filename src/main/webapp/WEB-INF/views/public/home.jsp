
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gym Management - Home</title>
    <style>
        body {
            margin: 0;
            font-family: Arial;
            background: #fff;
        }

        /* HEADER */
        .header {
            background: #d32f2f;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }

        .header a:hover {
            text-decoration: underline;
        }

        /* HERO */
        .hero {
            text-align: center;
            padding: 80px 20px;
            background: #f5f5f5;
        }

        .hero h1 {
            color: #d32f2f;
            font-size: 40px;
        }

        .hero p {
            font-size: 18px;
            margin-top: 10px;
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background: #d32f2f;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }

        .btn:hover {
            background: #b71c1c;
        }

        /* SECTION */
        .section {
            padding: 50px;
            text-align: center;
        }

        .card {
            display: inline-block;
            width: 250px;
            margin: 15px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .card h3 {
            color: #d32f2f;
        }

        /* FOOTER */
        .footer {
            background: #d32f2f;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 50px;
        }
    </style>
</head>
<body>

<!-- HEADER -->
<div class="header">
    <h2>🏋️ Gym System</h2>

    <div>
        <a href="/">Trang chủ</a>
        <a href="/login">Đăng nhập</a>
        <a href="/register">Đăng ký</a>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <h1>Chào mừng đến Gym Management</h1>
    <p>Quản lý phòng gym dễ dàng - nhanh chóng - hiệu quả</p>

    <a href="/register" class="btn">Tham gia ngay</a>
</div>

<!-- FEATURES -->
<div class="section">
    <h2>Dịch vụ của chúng tôi</h2>

    <div class="card">
        <h3>💪 Tập luyện</h3>
        <p>Thiết bị hiện đại, không gian chuyên nghiệp</p>
    </div>

    <div class="card">
        <h3>🏃 Huấn luyện viên</h3>
        <p>Trainer giàu kinh nghiệm hỗ trợ bạn</p>
    </div>

    <div class="card">
        <h3>📅 Lịch tập</h3>
        <p>Dễ dàng đăng ký và theo dõi lịch tập</p>
    </div>
</div>

<!-- FOOTER -->
<div class="footer">
    <p>© 2026 Gym Management System</p>
</div>

</body>
</html>