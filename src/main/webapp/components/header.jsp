<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <header class="header">

        <div class="logo">
            <a href="${pageContext.request.contextPath}/pages/index.html">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"
                    style="height: 40px; vertical-align: middle;">
            </a>
        </div>

        <nav class="menu">
            <a href="${pageContext.request.contextPath}/pages/clubs.jsp">CLB</a>
            <a href="${pageContext.request.contextPath}/pages/services.jsp">Dịch vụ</a>
            <a href="${pageContext.request.contextPath}/pages/schedule.jsp">Lịch học</a>
            <a href="${pageContext.request.contextPath}/pages/pricing.jsp">Chính sách giá</a>
            <a href="${pageContext.request.contextPath}/pages/contact.jsp">Liên hệ</a>
            <a href="${pageContext.request.contextPath}/pages/promotions.jsp">Khuyến mãi</a>
        </nav>

        <div class="actions">

            <button class="trial" onclick="window.location.href='${pageContext.request.contextPath}/pages/register.jsp'">Đăng ký tập thử</button>
            <button class="login" onclick="window.location.href='${pageContext.request.contextPath}/pages/login.jsp'">Đăng nhập</button>

        </div>

    </header>