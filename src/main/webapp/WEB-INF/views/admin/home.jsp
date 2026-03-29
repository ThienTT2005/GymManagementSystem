
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Gym Management</title>
    <style>
        body {
            font-family: Arial;
            margin: 0;
            background: #fff;
        }

        .header {
            background: #e60023;
            color: white;
            padding: 15px;
            text-align: center;
        }

        .nav {
            text-align: right;
            padding: 10px 20px;
        }

        .nav a {
            margin-left: 15px;
            text-decoration: none;
            color: #e60023;
            font-weight: bold;
        }

        .banner {
            text-align: center;
            margin-top: 100px;
        }

        h1 {
            color: #e60023;
            font-size: 40px;
        }

        p {
            font-size: 18px;
        }

        .btn {
            padding: 12px 25px;
            background: #e60023;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            margin: 10px;
            display: inline-block;
        }

        .btn:hover {
            background: #b8001c;
        }
    </style>
</head>
<body>

<div class="header">
    <h2>GYM MANAGEMENT SYSTEM</h2>
</div>

<div class="nav">
    <a href="/login">Login</a>
    <a href="/register">Register</a>
</div>

<div class="banner">
    <h1>Welcome to Gym 💪</h1>
    <p>Quản lý phòng gym chuyên nghiệp</p>

    <a href="/login" class="btn">Đăng nhập</a>
    <a href="/register" class="btn">Đăng ký</a>
</div>

</body>
</html>