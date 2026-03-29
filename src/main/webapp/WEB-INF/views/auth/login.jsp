<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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
        }
        .error { color: red; }
    </style>
</head>
<body>

<div class="box">
    <h2>Đăng nhập</h2>

    <c:if test="${error != null}">
        <p class="error">${error}</p>
    </c:if>

    <form action="/login" method="post" autocomplete="off">
        <input type="text" name="username" placeholder="Username" autocomplete="off" />
        <input type="password" name="password" placeholder="Password" autocomplete="new-password"/>
        <button type="submit">Đăng nhập</button>
    </form>

        <a href="/register">Chưa có tài khoản ? Đăng ký</a>
     <br><br>
    <a href="/">Về trang chủ</a>
</div>
<script>
    window.onload = function() {
        document.querySelectorAll("input").forEach(i => i.value = "");
    };
</script>
</body>
</html>