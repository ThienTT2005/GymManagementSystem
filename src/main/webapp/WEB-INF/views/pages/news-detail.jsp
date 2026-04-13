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

            <jsp:include page="/components/header.jsp" />

            <main class="news-detail-page">
                <div class="news-detail-container">
                    <div class="news-breadcrumb">
                        <a href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
                        <span>/</span>
                        <a href="${pageContext.request.contextPath}/news">TIN TỨC CODEGYM</a>
                        <span>/</span>
                        <span class="current">${news.title}</span>
                    </div>

                    <div class="news-small-title">
                        TIN TỨC CODEGYM
                    </div>

                    <h1 class="news-main-title">
                        ${news.title}
                    </h1>

                    <div class="news-meta">
                        <span class="news-author">ADMIN</span>
                        <span>/</span>
                        <span class="news-date">${news.createdAt}</span>
                        <span>/</span>
                        <span class="news-category">${news.category}</span>
                    </div>

                    <c:if test="${not empty news.image}">
                        <div class="news-image-wrap">
                            <img src="${pageContext.request.contextPath}/uploads/${news.image}" alt="${news.title}"
                                class="news-image" style="max-height: 500px; width: 100%; object-fit: contain;">
                        </div>
                    </c:if>

                    <div class="news-content">
                        ${news.content}
                    </div>
                </div>
            </main>

            <jsp:include page="/components/footer.jsp" />

        </body>

        </html>