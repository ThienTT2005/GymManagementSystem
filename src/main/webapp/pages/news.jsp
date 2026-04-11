<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CODEGYM - Tin tức</title>

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/css/style.css?v=2" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/news.css?v=2" rel="stylesheet">
</head>
<body>

<jsp:include page="../components/header.jsp" />

<main class="promo-news-page">

    <!-- Banner -->
    <section class="promo-banner">
        <img
                src="https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
                alt="Tin tức phòng tập"
                class="promo-banner-image">
        <div class="promo-banner-overlay"></div>
        <h1 class="promo-banner-title">TIN TỨC</h1>
    </section>

    <!-- Danh mục -->
    <section class="promo-category-section">
        <div class="promo-category-list">

            <a href="${pageContext.request.contextPath}/news?page=0&size=9"
               class="promo-category-btn ${empty currentCategory ? 'active' : ''}">
                TẤT CẢ
            </a>

            <a href="${pageContext.request.contextPath}/news?page=0&size=9&category=BLOG"
               class="promo-category-btn ${currentCategory == 'BLOG' ? 'active' : ''}">
                BLOG
            </a>

            <a href="${pageContext.request.contextPath}/news?page=0&size=9&category=CAU_CHUYEN_HOI_VIEN"
               class="promo-category-btn ${currentCategory == 'CAU_CHUYEN_HOI_VIEN' ? 'active' : ''}">
                CÂU CHUYỆN HỘI VIÊN
            </a>

            <a href="${pageContext.request.contextPath}/news?page=0&size=9&category=KHUYEN_MAI"
               class="promo-category-btn ${currentCategory == 'KHUYEN_MAI' ? 'active' : ''}">
                KHUYẾN MÃI
            </a>
        </div>
    </section>

    <!-- Danh sách tin -->
    <section class="promo-news-section">
        <c:choose>
            <c:when test="${not empty newsPage.newsList}">
                <div class="promo-news-grid">
                    <c:forEach var="item" items="${newsPage.newsList}">
                        <article class="promo-news-card">
                            <a href="${pageContext.request.contextPath}/news/${item.postId}">
                                <img class="promo-news-card-image"
                                     src="${pageContext.request.contextPath}${item.image}"
                                     alt="${item.title}">
                            </a>

                            <div class="promo-news-card-body">
                                <div class="promo-news-card-category">
                                    <c:choose>
                                        <c:when test="${item.category == 'BLOG'}">BLOG</c:when>
                                        <c:when test="${item.category == 'CAU_CHUYEN_HOI_VIEN'}">CÂU CHUYỆN HỘI VIÊN</c:when>
                                        <c:when test="${item.category == 'KHUYEN_MAI'}">KHUYẾN MÃI</c:when>
                                        <c:otherwise>${item.category}</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="promo-news-card-title">
                                    <a href="${pageContext.request.contextPath}/news/${item.postId}" style="text-decoration: none; color: inherit;">
                                        ${item.title}
                                    </a>
                                </div>

                                <div class="promo-news-card-content">
                                        ${item.content}
                                </div>

                                <div class="promo-news-card-date">
                                    Ngày đăng: ${item.createdAt}
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <div class="promo-empty">
                    Chưa có tin tức nào.
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- Phân trang -->
    <section class="promo-pagination-section">
        <c:if test="${newsPage.totalPages > 1}">
            <div class="promo-pagination">

                <!-- Prev -->
                <c:choose>
                    <c:when test="${newsPage.hasPrevious}">
                        <a class="promo-page-btn"
                           href="${pageContext.request.contextPath}/news?page=${newsPage.currentPage - 1}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
                            &lt;
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="promo-page-btn disabled">&lt;</span>
                    </c:otherwise>
                </c:choose>

                <!-- Số trang -->
                <c:forEach var="i" begin="0" end="${newsPage.totalPages - 1}">
                    <a class="promo-page-btn ${i == newsPage.currentPage ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/news?page=${i}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
                            ${i + 1}
                    </a>
                </c:forEach>

                <!-- Next -->
                <c:choose>
                    <c:when test="${newsPage.hasNext}">
                        <a class="promo-page-btn"
                           href="${pageContext.request.contextPath}/news?page=${newsPage.currentPage + 1}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
                            &gt;
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="promo-page-btn disabled">&gt;</span>
                    </c:otherwise>
                </c:choose>

            </div>
        </c:if>
    </section>

    <jsp:include page="../components/formtuvan.jsp" />
</main>

<jsp:include page="../components/footer.jsp" />

</body>
</html>