<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${news.title}</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news-detail.css">
</head>
<body>

<jsp:include page="/components/header.jsp"/>

<main class="news-detail-page">
    <div class="news-detail-container">
        <div class="news-breadcrumb">
            <a href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/news">TIN TỨC GYM PRO</a>
            <span>/</span>
            <span class="current">${news.title}</span>
        </div>

        <div class="news-small-title">
            TIN TỨC GYM PRO
        </div>

        <h1 class="news-main-title">
            ${news.title}
        </h1>

        <div class="news-meta">
            <span class="news-author">ADMIN</span>
            <span>/</span>
            <span class="news-date">${news.createdAt}</span>
            <span>/</span>
            <span class="news-category">
                <c:choose>
                    <c:when test="${news.type == 'NEWS'}">TIN TỨC</c:when>
                    <c:when test="${news.type == 'PROMOTION'}">KHUYẾN MÃI</c:when>
                    <c:when test="${news.type == 'BLOG'}">BLOG</c:when>
                    <c:when test="${news.type == 'STORY'}">CÂU CHUYỆN HỘI VIÊN</c:when>
                    <c:otherwise>${news.type}</c:otherwise>
                </c:choose>
            </span>
        </div>

        <div class="news-image-wrap">
            <c:choose>
                <c:when test="${not empty news.image}">
                    <img src="${pageContext.request.contextPath}/uploads/${news.image}"
                         alt="${news.title}"
                         class="news-image"
                         style="max-height: 500px; width: 100%; object-fit: contain;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/images/default-news.png"
                         alt="${news.title}"
                         class="news-image"
                         style="max-height: 500px; width: 100%; object-fit: contain;">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="news-content">
            ${news.content}
        </div>
    </div>
</main>

<jsp:include page="/components/footer.jsp"/>

</body>
</html>