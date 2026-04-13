<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập</title>
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
            .forgot {
                margin-top: 12px;
                color: #fff;
                font-size: 14px;
                cursor: pointer;
                text-decoration: underline;
            }

            .forgot:hover {
                color: #ffcccc;
            }

            .hotline-text {
                margin-top: 10px;
                color: #ffb3b3;
                font-size: 14px;
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

            .btn-login {
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

            .btn-login:hover {
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
    </head>
    <body>
        <div class="container">
            <div class="left">
                <div class="box">
                    <h2>Đăng nhập</h2>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
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
                                   name="password"
                                   placeholder="Mật khẩu"
                                   autocomplete="current-password"
                                   required>
                        </div>

                        <button type="submit" class="btn-login">Đăng nhập</button>
                        <p class="forgot" onclick="showHotline()">Quên mật khẩu?</p>
                        <p id="hotline" class="hotline-text"></p>
                    </form>

                    <div class="link">
                        <a href="${pageContext.request.contextPath}/register">Chưa có tài khoản? Đăng ký</a>
                        <a href="${pageContext.request.contextPath}/">Về trang chủ</a>
                    </div>
                </div>
                <script>
                    function showHotline() {
                        document.getElementById("hotline").innerText =
                                "Hãy liên lạc với số hotline 012 để được hỗ trợ!";
                    }
                </script>
            </div>

            <div class="right">
                <div class="ad-box">
                    <h1>Transform Your Body</h1>
                    <p>
                        Tham gia phòng gym hiện đại với huấn luyện viên chuyên nghiệp.
                        Tăng cơ, giảm mỡ, nâng cao sức khỏe ngay hôm nay.
                    </p>
                </div>
            </div>
        </div>
    </body>
</html>