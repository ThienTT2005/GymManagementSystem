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
            width: 48%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .right {
            width: 52%;
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
            max-width: 520px;
            padding: 36px 30px;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            text-align: left;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            color: #fff;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 700;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 14px 15px;
            border-radius: 10px;
            border: none;
            background: rgba(255, 255, 255, 0.88);
            color: #222;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 90px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 61, 61, 0.25);
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            margin-top: 16px;
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
                min-height: auto;
                padding-top: 30px;
            }

            .right {
                min-height: 30vh;
                padding-top: 0;
            }

            .ad-box h1 {
                font-size: 34px;
            }
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .left,
            .right {
                padding: 20px;
            }

            .box {
                padding: 28px 20px;
            }

            .ad-box h1 {
                font-size: 28px;
            }

            .ad-box p {
                font-size: 16px;
            }
        }
    </style>
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

                <div class="form-grid">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text"
                               id="username"
                               name="username"
                               placeholder="Tên đăng nhập"
                               value="${username}"
                               autocomplete="username"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="fullName">Họ và tên</label>
                        <input type="text"
                               id="fullName"
                               name="fullName"
                               placeholder="Họ và tên"
                               value="${fullName}"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Mật khẩu"
                               autocomplete="new-password"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Nhập lại mật khẩu</label>
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Nhập lại mật khẩu"
                               autocomplete="new-password"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text"
                               id="phone"
                               name="phone"
                               placeholder="Số điện thoại"
                               value="${phone}"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="Email"
                               value="${email}">
                    </div>

                    <div class="form-group">
                        <label for="gender">Giới tính</label>
                        <select id="gender" name="gender">
                            <option value="">-- Chọn --</option>
                            <option value="Male" ${gender == 'Male' ? 'selected' : ''}>Nam</option>
                            <option value="Female" ${gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            <option value="Other" ${gender == 'Other' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dob">Ngày sinh</label>
                        <input type="date"
                               id="dob"
                               name="dob"
                               value="${dob}">
                    </div>

                    <div class="form-group full-width">
                        <label for="address">Địa chỉ</label>
                        <textarea id="address"
                                  name="address"
                                  placeholder="Địa chỉ">${address}</textarea>
                    </div>
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
        const password = document.getElementById("password").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();
        const username = document.getElementById("username").value.trim();
        const fullName = document.getElementById("fullName").value.trim();
        const phone = document.getElementById("phone").value.trim();
        const errorClient = document.getElementById("errorClient");

        errorClient.style.display = "none";
        errorClient.innerText = "";

        if (!username || !fullName || !phone || !password || !confirmPassword) {
            errorClient.innerText = "Vui lòng nhập đầy đủ các trường bắt buộc";
            errorClient.style.display = "block";
            return false;
        }

        if (password.length < 6) {
            errorClient.innerText = "Mật khẩu phải có ít nhất 6 ký tự";
            errorClient.style.display = "block";
            return false;
        }

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