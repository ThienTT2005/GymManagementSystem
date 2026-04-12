<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            background: url('https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b') no-repeat center center;
            background-size: cover;
            position: relative;
        }

        body::before {
            content: "";
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            z-index: 1;
        }

        .container {
            position: relative;
            z-index: 2;
            display: flex;
            width: 100%;
            min-height: 100vh;
        }

        .left {
            width: 42%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .right {
            width: 58%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            padding: 50px;
            text-align: center;
        }

        .ad-box {
            max-width: 520px;
        }

        .ad-box h1 {
            font-size: 42px;
            margin-bottom: 18px;
            line-height: 1.2;
        }

        .ad-box p {
            font-size: 18px;
            opacity: 0.95;
            line-height: 1.7;
        }

        .box {
            width: 100%;
            max-width: 410px;
            padding: 42px 34px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.16);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.35);
            text-align: center;
        }

        .box h2 {
            color: #ff4d4f;
            margin-bottom: 22px;
            font-size: 30px;
        }

        .error {
            margin-bottom: 14px;
            padding: 12px 14px;
            border-radius: 10px;
            background: rgba(255, 77, 79, 0.18);
            border: 1px solid rgba(255, 77, 79, 0.35);
            color: #ffe1e1;
            font-size: 14px;
            text-align: left;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px;
            border-radius: 10px;
            border: none;
            background: rgba(255, 255, 255, 0.88);
            color: #222;
            font-size: 14px;
        }

        .form-group input:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 61, 61, 0.25);
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            margin-top: 4px;
            background: linear-gradient(45deg, #ff3d3d, #c62828);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s ease;
        }

        .btn-register:hover {
            box-shadow: 0 0 16px rgba(255, 0, 0, 0.45);
            transform: translateY(-1px);
        }

        .link {
            margin-top: 18px;
        }

        .link a {
            color: #ffffff;
            text-decoration: none;
            display: block;
            margin-top: 8px;
            font-size: 14px;
        }

        .link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 992px) {
            .container {
                flex-direction: column;
            }

            .left,
            .right {
                width: 100%;
            }

            .left {
                min-height: 60vh;
            }

            .right {
                min-height: 40vh;
                padding-top: 0;
            }

            .ad-box h1 {
                font-size: 34px;
            }
        }

        @media (max-width: 576px) {
            .left,
            .right {
                padding: 20px;
            }

            .box {
                padding: 30px 22px;
            }

            .ad-box h1 {
                font-size: 28px;
            }

            .ad-box p {
                font-size: 16px;
            }
        }
    </style>

    <script>
        function validateForm() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const errorClient = document.getElementById("errorClient");

            errorClient.innerText = "";

            if (password !== confirmPassword) {
                errorClient.innerText = "Mật khẩu không khớp";
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
<div class="container">
    <div class="left">
        <div class="box">
            <h2>Đăng ký</h2>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <div id="errorClient" class="error" style="display: none;"></div>

            <form action="${pageContext.request.contextPath}/register"
                  method="post"
                  onsubmit="return validateRegisterForm()">
                <div class="form-group">
                    <input type="text"
                           name="username"
                           placeholder="Tên đăng nhập"
                           value="${username}"
                           autocomplete="username"
                           required>
                </div>

                <div class="form-group">
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Mật khẩu"
                           autocomplete="new-password"
                           required>
                </div>

                <div class="form-group">
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="Nhập lại mật khẩu"
                           autocomplete="new-password"
                           required>
                </div>

                <button type="submit" class="btn-register">Đăng ký</button>
            </form>

            <div class="link">
                <a href="${pageContext.request.contextPath}/login">Đã có tài khoản? Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/">Về trang chủ</a>
            </div>
        </div>
    </div>

    <div class="right">
        <div class="ad-box">
            <h1>Join & Transform</h1>
            <p>
                Bắt đầu hành trình tập luyện ngay hôm nay với hệ thống gym hiện đại,
                huấn luyện viên chuyên nghiệp và môi trường luyện tập đầy cảm hứng.
            </p>
        </div>
    </div>
</div>

<script>
    function validateRegisterForm() {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        const errorClient = document.getElementById("errorClient");

        errorClient.style.display = "none";
        errorClient.innerText = "";

        if (password !== confirmPassword) {
            errorClient.innerText = "Mật khẩu không khớp";
            errorClient.style.display = "block";
            return false;
        }

        return true;
    }
</script>
</body>
</html>