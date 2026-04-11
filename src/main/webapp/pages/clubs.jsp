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
    </head>

    <body>
        <!-- Header Component -->
        <jsp:include page="../components/header.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Section -->
            <section class="hero">
                <div class="container-inner">
                    <h1 class="hero-title">CÂU LẠC BỘ </h1>
                    <p class="hero-description">
                        Khám phá hệ thống phòng tập CODEGYM hiện đại, đa dạng.
                    </p>

                    <!-- Clubs Selection -->
                    <div class="clubs-section">
                        <div class="club-featured">
                            <div class="club-featured-info">
                                <h3 class="club-name">CODEGYM HÀ ĐÔNG</h3>
                                <div class="club-info-details">
                                    <p class="club-address">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" text-algin="left">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                            <circle cx="12" cy="10" r="3"></circle>
                                        </svg>
                                        Tòa nhà Ellipse - 112 Trần Phú, Hà Đông
                                    </p>
                                    <p class="club-phone">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path
                                                d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z">
                                            </path>
                                        </svg>
                                        0987 523 311
                                    </p>
                                </div>
                            </div>
                            <div class="club-featured-image">
                                <img src="../images/HÀ ĐÔNG.jpg" alt="CODEGYM HÀ ĐÔNG">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Registration Section -->
            <!-- Form đăng ký -->
            <jsp:include page="/components/formtuvan.jsp" />
            <jsp:include page="/components/footer.jsp" />
    </body>

    </html>