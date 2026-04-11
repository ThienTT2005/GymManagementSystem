<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AEROBICS - CODEGYM</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zumba.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="zumba-page">
    <!-- Banner -->
    <section class="zumba-banner">
        <img
                src="${pageContext.request.contextPath}/images/aerobic-8.png"
                alt="Aerobics banner"
                class="zumba-banner-image"
        >
        <div class="zumba-banner-overlay"></div>

        <div class="zumba-banner-content">
            <p class="zumba-breadcrumb"><a href="${pageContext.request.contextPath}/pages/services.jsp" style="color: inherit; text-decoration: none;">DỊCH VỤ</a> &gt; AEROBICS</p>
            <h1 class="zumba-banner-title">AEROBICS</h1>
        </div>
    </section>

    <!-- Giới thiệu -->
    <section class="zumba-intro">
        <div class="zumba-intro-text">
            <h2 class="section-title">Z</h2>
            <p class="section-description">
                AEROBICS Aerobic là bộ môn không những giúp cơ thể bạn linh
                hoạt, dẻo dai, chúng còn giúp tinh thần bạn sảng
                khoái và suy nghĩ tích cực hơn. Aerobic có thể được
                xem là bộ môn luyện tập giúp nâng cao sức khoẻ toàn
                diện.
            </p>
        </div>

        <div class="zumba-intro-image">
            <img
                    src="${pageContext.request.contextPath}/images/run.png"
                    alt="Lớp học aerobics"
            >
        </div>
    </section>

    <!-- Thông số -->
    <section class="zumba-info-section">
        <div class="zumba-info-grid">
            <div class="zumba-info-card">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
                <h3>THỜI LƯỢNG</h3>
                <p>60 phút</p>
            </div>

            <div class="zumba-info-card">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path>
                </svg>
                <h3>CALORIES</h3>
                <p>250 - 600</p>
            </div>

            <div class="zumba-info-card">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                    <circle cx="12" cy="10" r="3"></circle>
                </svg>
                <h3>ĐỊA CHỈ</h3>
                <p>Hà Đông</p>
            </div>

            <div class="zumba-info-card">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                <h3>KỸ NĂNG</h3>
                <p>Dành cho mọi người</p>
            </div>
        </div>
    </section>

    <!-- Lợi ích -->
    <section class="zumba-benefits-section">
        <div class="zumba-benefits-header">
            <img
                    src="${pageContext.request.contextPath}/images/banner.png"
                    alt="Aerobics benefit"
                    class="zumba-benefits-banner"
            >
            <p class="zumba-benefits-description">
                Aerobic là sự kết hợp hoàn hảo giữa âm nhạc và vận động toàn thân, giúp bạn kiểm soát cân nặng,
                tăng cường hệ miễn dịch và duy trì một tinh thần sảng khoái, tràn đầy sức sống.
            </p>
        </div>

        <div class="zumba-benefits-grid">
            <article class="benefit-card">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2dd4bf" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                </svg>
                <h3>TĂNG CƯỜNG SỨC MẠNH</h3>
                <p>
                    Các bài tập cường độ vừa và cao giúp cải thiện sức bền cơ bắp, tăng khả năng vận động
                    và hỗ trợ đốt cháy mỡ thừa hiệu quả.
                </p>
            </article>

            <article class="benefit-card">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2dd4bf" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                    <path d="M6.5 6.5l11 11"></path><path d="M21 21l-1-1"></path><path d="M3 3l1 1"></path><path d="M18 22l4-4"></path><path d="M2 6l4-4"></path><path d="M3 10l7-7"></path><path d="M14 21l7-7"></path>
                </svg>
                <h3>CƠ BẮP DẺO DAI</h3>
                <p>
                    Các bài tập giãn cơ phối hợp trong Aerobic giúp giải phóng sự căng cứng của khớp,
                    duy trì sự linh hoạt và ngăn ngừa các vấn đề về xương khớp.
                </p>
            </article>

            <article class="benefit-card">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2dd4bf" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                </svg>
                <h3>CƠ THỂ VỮNG CHÃI</h3>
                <p>
                    Sự phối hợp nhịp nhàng giữa tay và chân trên nền nhạc nhanh giúp rèn luyện khả năng
                    phản xạ, giữ thăng bằng tốt hơn và làm khung xương thêm chắc khỏe.
                </p>
            </article>

            <article class="benefit-card">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2dd4bf" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                </svg>
                <h3>SỨC KHỎE BỀN BỈ</h3>
                <p>
                    Vận động liên tục giúp tim phổi hoạt động hiệu quả hơn, nâng cao sức chịu đựng
                    và giúp bạn duy trì năng lượng làm việc suốt cả ngày dài.
                </p>
            </article>
        </div>
    </section>

    <jsp:include page="/components/formtuvan.jsp" />
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>