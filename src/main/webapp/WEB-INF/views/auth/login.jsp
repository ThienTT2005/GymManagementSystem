<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        .box {
            margin: 100px auto;
            width: 320px;
            padding: 24px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }

        h2 {
            color: #d32f2f;
            margin-top: 0;
            margin-bottom: 20px;
        }

        input {
            width: 100%;
            padding: 10px 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
        }

        button {
            background: #d32f2f;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            margin-top: 8px;
        }

        button:hover {
            background: #b71c1c;
        }

        .error {
            color: red;
            margin-bottom: 12px;
        }

        .links {
            margin-top: 18px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .links a {
            color: #d32f2f;
            text-decoration: none;
            font-size: 14px;
        }

        .links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>Đăng nhập</h2>

    <c:if test="${not empty errorMessage}">
        <p class="error">${errorMessage}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
        <input type="text"
               name="username"
               placeholder="Username"
               value="${username}"
               autocomplete="off" />

        <input type="password"
               name="password"
               placeholder="Password"
               autocomplete="new-password" />

        <button type="submit">Đăng nhập</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/register">Chưa có tài khoản? Đăng ký</a>
        <a href="${pageContext.request.contextPath}/">Về trang chủ</a>
    </div>
</div>

<script>
    window.onload = function() {
        const passwordInput = document.querySelector("input[type='password']");
        if (passwordInput) {
            passwordInput.value = "";
        }
    };
</script>
</body>
</html>