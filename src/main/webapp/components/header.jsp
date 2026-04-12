<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/page-transitions.css?v=1">

    <header class="header nav-transition">

        <div class="logo">
            <a href="${pageContext.request.contextPath}/index">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"
                    style="height: 40px; vertical-align: middle;">
            </a>
        </div>

        <nav class="menu nav-transition">
            <a href="${pageContext.request.contextPath}/index">HOME</a>
            <a href="${pageContext.request.contextPath}/services">DỊCH VỤ</a>
            <a href="${pageContext.request.contextPath}/pricing">CHÍNH SÁCH GIÁ</a>
            <a href="${pageContext.request.contextPath}/pages/contact.jsp">LIÊN HỆ</a>
            <a href="${pageContext.request.contextPath}/news">TIN TỨC </a>
        </nav>

        <div class="actions">

            <button class="trial"
                onclick="window.location.href='${pageContext.request.contextPath}/pages/register.jsp'">ĐĂGN KÝ TẬP THỬ</button>
            <button class="login"
                onclick="window.location.href='${pageContext.request.contextPath}/pages/login.jsp'">ĐĂNG NHẬP</button>

        </div>

    </header>