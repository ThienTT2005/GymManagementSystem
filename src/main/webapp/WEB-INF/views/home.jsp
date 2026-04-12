<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PTIT Gym - Welcome</title>
        <style>
            /* Dùng chung màu sắc với trang Login */
            body { 
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                background: linear-gradient(120deg, #2980b9, #8e44ad);
                margin: 0; min-height: 100vh; color: white;
            }
            
            /* Thanh điều hướng phía trên */
            .navbar {
                display: flex; justify-content: space-between; align-items: center;
                padding: 15px 50px; background: rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(5px); /* Làm mờ nhẹ nền */
            }

            /* Chỗ dán Logo */
            .logo-container img {
                height: 100px; /* Bạn có thể chỉnh độ cao logo ở đây */
                width: auto;
                border-radius: 5px;
            }

            .nav-links a {
                color: white; text-decoration: none; font-weight: bold;
                padding: 10px 20px; border: 2px solid white; border-radius: 5px;
                transition: 0.3s;
            }

            .nav-links a:hover {
                background: white; color: #2980b9;
            }

            /* Phần nội dung quảng cáo */
            .hero-section {
                text-align: center; padding: 100px 20px;
            }

            .hero-section h1 { font-size: 3em; margin-bottom: 10px; text-shadow: 2px 2px 10px rgba(0,0,0,0.3); }
            .hero-section p { font-size: 1.2em; opacity: 0.9; margin-bottom: 30px; }

            .promo-box {
                background: white; color: #333; display: inline-block;
                padding: 30px; border-radius: 15px; box-shadow: 0 15px 25px rgba(0,0,0,0.3);
                max-width: 600px;
            }
            
            .promo-box h2 { color: #8e44ad; }
            .btn-start {
                display: inline-block; margin-top: 20px;
                padding: 12px 30px; background: #3498db; color: white;
                text-decoration: none; border-radius: 5px; font-weight: bold;
            }
            .btn-start:hover { background: #2980b9; }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="logo-container">
                <img src="https://i.postimg.cc/y8mtt5t4/anh-phong-gym.jpg" alt="PTIT Gym Logo">
            </div>
            <div class="nav-links">
                <a href="login">ĐĂNG KÝ / ĐĂNG NHẬP</a>
            </div>
        </div>

        <div class="hero-section">
            <h1>PTIT GYM CENTER</h1>
            <p>Nâng tầm vóc dáng - Khẳng định bản lĩnh sinh viên</p>
            
            <div class="promo-box">
                <h2>ƯU ĐÃI THÁNG 3</h2>
                <p>Giảm ngay <b>50%</b> học phí cho tất cả sinh viên PTIT khóa mới.</p>
                <p>Miễn phí 1 tuần tập thử cùng huấn luyện viên cá nhân (PT).</p>
                <a href="login" class="btn-start">BẮT ĐẦU NGAY</a>
            </div>
        </div>

    </body>
</html>