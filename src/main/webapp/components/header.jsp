<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/page-transitions.css?v=1">

<header class="header nav-transition">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"
                 style="height: 40px; vertical-align: middle;">
        </a>
    </div>

    <nav class="menu nav-transition">
        <a href="${pageContext.request.contextPath}/">HOME</a>
        <a href="${pageContext.request.contextPath}/services">DỊCH VỤ</a>
        <a href="${pageContext.request.contextPath}/pricing">CHÍNH SÁCH GIÁ</a>
        <a href="${pageContext.request.contextPath}/news">TIN TỨC</a>
        <a href="${pageContext.request.contextPath}/contact">LIÊN HỆ </a>
    </nav>

    <div class="actions">
        <button class="trial"
                onclick="window.location.href='${pageContext.request.contextPath}/pages/register'">ĐĂNG KÝ TẬP THỬ</button>
        <button class="login"
                onclick="window.location.href='${pageContext.request.contextPath}/login'">ĐĂNG NHẬP</button>
    </div>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const contextPath = '${pageContext.request.contextPath}';
        const navLinks = document.querySelectorAll('.menu a');

        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            
            // So sánh đường dẫn hiện tại với href của link
            // Xử lý các trường hợp có/không có context path và dấu gạch chéo cuối
            if (currentPath === href || 
                currentPath === href + '/' || 
                (href === contextPath + '/' && currentPath === contextPath) ||
                (currentPath.startsWith(href) && href !== contextPath && href !== contextPath + '/')) {
                link.classList.add('active');
            }
        });
    });
</script>