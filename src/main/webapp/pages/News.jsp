<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CODEGYM - Câu Lạc Bộ</title>
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <!-- Style cho Header và Footer -->
        <link href="${pageContext.request.contextPath}/css/style.css?v=2" rel="stylesheet">
        <!-- Style cho định dạng thân trang Clubs -->
        <link href="../css/clubs.css?v=2" rel="stylesheet">
        <link href="../css/News.css?v=2" rel="stylesheet">
    </head>

    <body>
        <!-- Header Component -->
        <jsp:include page="../components/header.jsp" />
        <main class="promo-news-page">
            <!-- Banner -->
            <section class="promo-banner">
                <img src="https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
                    alt="Tin tức phòng tập" class="promo-banner-image">
                <div class="promo-banner-overlay"></div>
                <h1 class="promo-banner-title">TIN TỨC</h1>
            </section>

            <!-- Menu danh mục -->
            <section class="promo-category-section">
                <div class="promo-category-list" id="promoCategoryList">
                    <button type="button" class="promo-category-btn active" data-category="">TẤT CẢ</button>
                    <button type="button" class="promo-category-btn" data-category="BLOG">BLOG</button>
                    <button type="button" class="promo-category-btn" data-category="CAU_CHUYEN_HOI_VIEN">CÂU CHUYỆN HỘI
                        VIÊN</button>
                    <button type="button" class="promo-category-btn" data-category="KHUYEN_MAI">KHUYẾN MÃI</button>
                </div>
            </section>

            <!-- Danh sách tin -->
            <section class="promo-news-section">
                <div class="promo-news-grid" id="promoNewsGrid">
                    <!-- JS render 9 tin / trang -->
                </div>

                <div class="promo-empty" id="promoEmptyMessage" style="display: none;">
                    Chưa có tin tức nào.
                </div>
            </section>

            <!-- Phân trang -->
            <section class="promo-pagination-section">
                <div class="promo-pagination" id="promoPagination">
                    <!-- JS render phân trang -->
                </div>
            </section>

            <!-- Form đăng ký nhận tư vấn -->
            <jsp:include page="/components/formtuvan.jsp" />
        </main>
        <script>
            const contextPath = "${pageContext.request.contextPath}";

            const promoState = {
                category: "",
                page: 1,
                size: 9
            };

            const promoNewsGrid = document.getElementById("promoNewsGrid");
            const promoPagination = document.getElementById("promoPagination");
            const promoEmptyMessage = document.getElementById("promoEmptyMessage");
            const promoCategoryList = document.getElementById("promoCategoryList");

            async function loadPromoNews() {
                try {
                    const query = new URLSearchParams({
                        page: promoState.page,
                        size: promoState.size
                    });

                    if (promoState.category) {
                        query.append("category", promoState.category);
                    }

                    const response = await fetch(contextPath + "/api/news?" + query.toString());

                    if (!response.ok) {
                        throw new Error("API lỗi");
                    }

                    const data = await response.json();

                    renderPromoNews(data.content);
                    renderPromoPagination(data.page, data.totalPages);

                } catch (error) {
                    console.error("Lỗi load dữ liệu:", error);
                    promoEmptyMessage.style.display = "block";
                    promoEmptyMessage.textContent = "Không tải được dữ liệu từ server";
                }
            }

            function renderPromoNews(newsList) {
                promoNewsGrid.innerHTML = "";

                if (!newsList || newsList.length === 0) {
                    promoEmptyMessage.style.display = "block";
                    promoEmptyMessage.textContent = "Chưa có tin tức nào.";
                    return;
                }

                promoEmptyMessage.style.display = "none";

                newsList.forEach(news => {
                    const imageUrl = news.imageUrl && news.imageUrl.startsWith("http")
                        ? news.imageUrl
                        : `\${contextPath}/\${(news.imageUrl || "").replace(/^\\/+/, "")}`;

                    const card = document.createElement("article");
                    card.className = "promo-news-card"; // ✅ sửa ở đây

                    card.innerHTML = `
                    <img class="promo-news-card-image" src="\${imageUrl}" alt="\${escapeHtml(news.title)}">
                    <div class="promo-news-card-body">
                        <div class="promo-news-card-category">\${formatCategory(news.category)}</div>
                        <div class="promo-news-card-title">\${escapeHtml(news.title)}</div>
                        <div class="promo-news-card-content">\${escapeHtml(shortenText(news.content, 140))}</div>
                        <div class="promo-news-card-date">Ngày đăng: \${formatDate(news.createdAt)}</div>
                    </div>
                `;

                    promoNewsGrid.appendChild(card);
                });
            }

            function renderPromoPagination(currentPage, totalPages) {
                promoPagination.innerHTML = "";

                const prevBtn = createPageButton("<", currentPage === 1, () => {
                    promoState.page--;
                    loadPromoNews();
                });
                promoPagination.appendChild(prevBtn);

                for (let i = 1; i <= totalPages; i++) {
                    const btn = createPageButton(i, false, () => {
                        promoState.page = i;
                        loadPromoNews();
                    });

                    if (i === currentPage) {
                        btn.classList.add("active");
                    }

                    promoPagination.appendChild(btn);
                }

                const nextBtn = createPageButton(">", currentPage === totalPages, () => {
                    promoState.page++;
                    loadPromoNews();
                });
                promoPagination.appendChild(nextBtn);

                const lastBtn = createPageButton("cuối >>", currentPage === totalPages, () => {
                    promoState.page = totalPages;
                    loadPromoNews();
                });
                promoPagination.appendChild(lastBtn);
            }

            function createPageButton(text, disabled, onClick) {
                const btn = document.createElement("button");
                btn.type = "button";
                btn.className = "promo-page-btn";
                btn.textContent = text;
                btn.disabled = disabled;
                btn.addEventListener("click", onClick);
                return btn;
            }

            promoCategoryList.addEventListener("click", function (e) {
                const btn = e.target.closest(".promo-category-btn");
                if (!btn) return;

                document.querySelectorAll(".promo-category-btn").forEach(item => {
                    item.classList.remove("active");
                });

                btn.classList.add("active");
                promoState.category = btn.dataset.category;
                promoState.page = 1;
                loadPromoNews();
            });

            function shortenText(text, maxLength) {
                if (!text) return "";
                return text.length > maxLength ? text.substring(0, maxLength) + "..." : text;
            }

            function formatDate(dateString) {
                if (!dateString) return "";
                const date = new Date(dateString);
                return date.toLocaleDateString("vi-VN");
            }

            function formatCategory(category) {
                switch (category) {
                    case "BLOG":
                        return "BLOG";
                    case "CAU_CHUYEN_HOI_VIEN":
                        return "CÂU CHUYỆN HỘI VIÊN";
                    case "KHUYEN_MAI":
                        return "KHUYẾN MÃI";
                    default:
                        return "TẤT CẢ";
                }
            }

            function escapeHtml(text) {
                if (!text) return "";
                return text
                    .replaceAll("&", "&amp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll('"', "&quot;")
                    .replaceAll("'", "&#039;");
            }



            loadPromoNews();
        </script>
    </body>

    </html>