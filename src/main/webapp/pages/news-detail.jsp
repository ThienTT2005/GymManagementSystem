<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${news.title}</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news-detail.css">
</head>
<body>

<!-- Header -->
<jsp:include page="../components/header.jsp" />

<main class="news-detail-page">
    <div class="news-detail-container">

        <!-- Breadcrumb -->
        <div class="news-breadcrumb">
            <a href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/news">TIN TỨC BLUEGYM</a>
            <span>/</span>
            <span class="current">${news.title}</span>
        </div>

        <!-- Tiêu đề nhỏ -->
        <div class="news-small-title">
            TIN TỨC BLUEGYM
        </div>

        <!-- Tiêu đề to -->
        <h1 class="news-main-title">
            ${news.title}
        </h1>

        <!-- Ngày giờ đăng tin + phân loại -->
        <div class="news-meta">
            <span class="news-author">ADMIN</span>
            <span>/</span>
            <span class="news-date">${news.createdAt}</span>
            <span>/</span>
            <span class="news-category">${news.category}</span>
        </div>

        <!-- Ảnh -->
        <c:if test="${not empty news.image}">
            <div class="news-image-wrap">
                <img src="${pageContext.request.contextPath}${news.image}" alt="${news.title}" class="news-image">
            </div>
        </c:if>

        <!-- Nội dung -->
        <div class="news-content">
            ${news.content}
        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="../components/footer.jsp" />

</body>
</html>