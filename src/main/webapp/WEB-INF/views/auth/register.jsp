<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial;
        }

        body {
            height: 100vh;
            display: flex;

            background: url('https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b') no-repeat center;
            background-size: cover;
        }

        /* overlay */
        body::before {
            content: "";
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
            z-index: 1;
        }

        .container {
            position: relative;
            z-index: 2;
            display: flex;
            width: 100%;
        }

        /* LEFT */
        .left {
            width: 40%;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding-left: 15%;
        }

        /* RIGHT */
        .right {
            width: 60%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            padding: 50px;
            text-align: center;
        }

        .ad-box {
            max-width: 500px;
        }

        .ad-box h1 {
            font-size: 40px;
            margin-bottom: 20px;
        }

        .ad-box p {
            font-size: 18px;
            opacity: 0.9;
            line-height: 1.5;
        }

        /* FORM */
        .box {
            width: 410px;
            padding: 45px;
            border-radius: 18px;

            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.2);

            box-shadow: 0 8px 30px rgba(0,0,0,0.4);
            text-align: center;
        }

        h2 {
            color: #ff3d3d;
            margin-bottom: 25px;
        }

        input {
            width: 100%;
            padding: 14px;
            margin: 12px 0;
            border-radius: 10px;
            border: none;
            background: rgba(255,255,255,0.8);
        }

        input:focus {
            outline: none;
            box-shadow: 0 0 8px rgba(255,0,0,0.5);
        }

        button {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            background: linear-gradient(45deg, #ff3d3d, #d32f2f);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            box-shadow: 0 0 15px rgba(255,0,0,0.6);
        }

        .link {
            margin-top: 15px;
        }

        .link a {
            color: white;
            text-decoration: none;
            display: block;
            margin-top: 5px;
        }

        .error {
            color: #ffb3b3;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>

    <script>
        function validateForm() {
            let pass = document.getElementById("password").value;
            let confirm = document.getElementById("confirm").value;
            let errorBox = document.getElementById("errorClient");

            errorBox.innerText = "";

            if (pass !== confirm) {
                errorBox.innerText = "Mật khẩu không khớp!";
                return false;
            }
            return true;
        }

        window.onload = function() {
            document.querySelectorAll("input").forEach(i => i.value = "");
        };
    </script>

</head>

<body>

<div class="container">

    <!-- LEFT -->
    <div class="left">
        <div class="box">
            <h2>Đăng ký</h2>

            <!-- ERROR SERVER -->
            <c:if test="${error != null}">
                <p class="error">${error}</p>
            </c:if>

            <!-- ERROR CLIENT -->
            <div id="errorClient" class="error"></div>

            <form action="/register" method="post" onsubmit="return validateForm()">
                
                <input type="text" name="username" placeholder="Username">
                <input type="password" id="password" name="password" placeholder="Password">
                <input type="password" id="confirm" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                <button type="submit">Đăng ký</button>
            </form>

            <div class="link">
                <a href="/login">Đã có tài khoản? Đăng nhập</a>
                <a href="/">Về trang chủ</a>
            </div>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right">
        <div class="ad-box">
            <h1>🔥 Join & Transform</h1>
            <p>
                Bắt đầu hành trình fitness ngay hôm nay.  
                HLV chuyên nghiệp - Thiết bị hiện đại - Kết quả rõ rệt!
            </p>
        </div>
    </div>

</div>

</body>
</html>