<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GYM PRO - Tin tức</title>

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/css/style.css?v=2" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/news.css?v=2" rel="stylesheet">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="promo-news-page">
    <section class="promo-banner">
        <img
                src="https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
                alt="Tin tức phòng tập"
                class="promo-banner-image">
        <div class="promo-banner-overlay"></div>
        <h1 class="promo-banner-title">TIN TỨC</h1>
    </section>

    <section class="promo-category-section">
        <div class="promo-category-list">
            <a href="${pageContext.request.contextPath}/news?page=1&size=9"
               class="promo-category-btn ${empty currentCategory ? 'active' : ''}">
                TẤT CẢ
            </a>

            <a href="${pageContext.request.contextPath}/news?page=1&size=9&category=BLOG"
               class="promo-category-btn ${currentCategory == 'BLOG' ? 'active' : ''}">
                BLOG
            </a>

            <a href="${pageContext.request.contextPath}/news?page=1&size=9&category=STORY"
               class="promo-category-btn ${currentCategory == 'STORY' ? 'active' : ''}">
                CÂU CHUYỆN HỘI VIÊN
            </a>

            <a href="${pageContext.request.contextPath}/news?page=1&size=9&category=PROMOTION"
               class="promo-category-btn ${currentCategory == 'PROMOTION' ? 'active' : ''}">
                KHUYẾN MÃI
            </a>

            <a href="${pageContext.request.contextPath}/news?page=1&size=9&category=NEWS"
               class="promo-category-btn ${currentCategory == 'NEWS' ? 'active' : ''}">
                TIN MỚI
            </a>
        </div>
    </section>

    <section class="promo-news-section">
        <c:choose>
            <c:when test="${not empty newsList}">
                <div class="promo-news-grid">
                    <c:forEach var="item" items="${newsList}">
                        <article class="promo-news-card">
                            <a href="${pageContext.request.contextPath}/news/${item.postId}">
                                <c:choose>
                                    <c:when test="${not empty item.image}">
                                        <img class="promo-news-card-image"
                                             src="${pageContext.request.contextPath}/uploads/${item.image}"
                                             alt="${item.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="promo-news-card-image"
                                             src="${pageContext.request.contextPath}/assets/images/default-news.png"
                                             alt="${item.title}">
                                    </c:otherwise>
                                </c:choose>
                            </a>

                            <div class="promo-news-card-body">
                                <div class="promo-news-card-category">
                                    <c:choose>
                                        <c:when test="${item.type == 'NEWS'}">TIN MỚI</c:when>
                                        <c:when test="${item.type == 'BLOG'}">BLOG</c:when>
                                        <c:when test="${item.type == 'STORY'}">CÂU CHUYỆN HỘI VIÊN</c:when>
                                        <c:when test="${item.type == 'PROMOTION'}">KHUYẾN MÃI</c:when>
                                        <c:otherwise>${item.type}</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="promo-news-card-title">
                                    <a href="${pageContext.request.contextPath}/news/${item.postId}"
                                       style="text-decoration: none; color: inherit;">
                                        <c:out value="${item.title}" />
                                    </a>
                                </div>

                                <div class="promo-news-card-content">
                                    <c:set var="words" value="${fn:split(item.content, ' ')}" />

                                    <c:choose>
                                        <c:when test="${fn:length(words) > 30}">
                                            <c:forEach var="w" items="${words}" begin="0" end="29">
                                                <c:out value="${w}" />&nbsp;
                                            </c:forEach>
                                            ...
                                        </c:when>

                                        <c:otherwise>
                                            <c:out value="${item.content}" />
                                        </c:otherwise>
                                    </c:choose>
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

    <section class="promo-pagination-section">
        <c:if test="${newsPage.totalPages > 1}">
            <div class="promo-pagination">
                <c:choose>
                    <c:when test="${newsPage.hasPrevious()}">
                        <a class="promo-page-btn"
                           href="${pageContext.request.contextPath}/news?page=${newsPage.number}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
                            &lt;
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="promo-page-btn disabled">&lt;</span>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="i" begin="1" end="${newsPage.totalPages}">
                    <a class="promo-page-btn ${i == newsPage.number + 1 ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/news?page=${i}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
                            ${i}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${newsPage.hasNext()}">
                        <a class="promo-page-btn"
                           href="${pageContext.request.contextPath}/news?page=${newsPage.number + 2}&size=9${not empty currentCategory ? '&category='.concat(currentCategory) : ''}">
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

    <h2 class="consult-form-title">ĐĂNG KÝ VÀ NHẬN TƯ VẤN</h2>
    <jsp:include page="/components/formtuvan.jsp" />
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>