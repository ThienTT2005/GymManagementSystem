<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <header class="header">

        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"
                style="height: 40px; vertical-align: middle;">
        </div>

        <nav class="menu">

            <a href="#">CLB</a>
            <a href="#">Dịch vụ</a>
            <a href="#">Lịch học</a>
            <a href="#">Chính sách giá</a>
            <a href="#">Liên hệ</a>
            <a href="#">Khuyến mãi</a>

        </nav>

        <div class="actions">

            <button class="trial" onclick="window.location.href='${pageContext.request.contextPath}/pages/register.jsp'">Đăng ký tập thử</button>
            <button class="login" onclick="window.location.href='${pageContext.request.contextPath}/pages/login.jsp'">Đăng nhập</button>

        </div>

    </header>