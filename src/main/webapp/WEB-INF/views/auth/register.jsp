<%@ page contentType="text/html;charset=UTF-8" %>


<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body { font-family: Arial; background: #f5f5f5; text-align: center; }
        .box {
            margin: 100px auto;
            width: 300px;
            padding: 20px;
            background: white;
            border: 1px solid #ddd;
        }
        h2 { color: #d32f2f; }
        input { width: 90%; padding: 8px; margin: 8px 0; }
        button {
            background: #d32f2f;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            cursor: pointer;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
    </style>

    <script>
        function validateForm() {
            let pass = document.getElementById("password").value;
            let confirm = document.getElementById("confirm").value;
            let errorBox = document.getElementById("errorClient");

            errorBox.innerText = ""; // reset lỗi

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

<div class="box">
    <h2>Đăng ký</h2>

    <!-- Lỗi từ server -->
    <c:if test="${error != null}">
        <div class="error">${error}</div>
    </c:if>

    <!-- Lỗi từ JS -->
    <div id="errorClient" class="error"></div>

    <form action="/register" method="post" onsubmit="return validateForm()">
        <input type="text" name="fullName" placeholder="Họ tên" autocomplete="off">
        <input type="text" name="username" placeholder="Username" autocomplete="off">

        <input type="password" id="password" name="password" placeholder="Password" autocomplete="new-password">
        <input type="password" id="confirm" name="confirmPassword" placeholder="Nhập lại mật khẩu" autocomplete="new-password">

        <button type="submit">Đăng ký</button>
    </form>

    <a href="/login">Đã có tài khoản? Đăng nhập</a>
    <br><br>
    <a href="/">Về trang chủ</a>
</div>

</body>
</html>