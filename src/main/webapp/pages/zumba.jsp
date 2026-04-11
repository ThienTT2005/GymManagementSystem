<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zumba - CODEGYM</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zumba.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="zumba-page">
    <!-- Banner -->
    <section class="zumba-banner">
        <img
                src="${pageContext.request.contextPath}/images/zumba-banner.png"
                alt="Zumba banner"
                class="zumba-banner-image"
        >
        <div class="zumba-banner-overlay"></div>

        <div class="zumba-banner-content">
            <p class="zumba-breadcrumb">DỊCH VỤ &gt; ZUMBA</p>
            <h1 class="zumba-banner-title">ZUMBA</h1>
        </div>
    </section>

    <!-- Giới thiệu -->
    <section class="zumba-intro">
        <div class="zumba-intro-text">
            <h2 class="section-title">ZUMBA</h2>
            <p class="section-description">
                Zumba là bộ môn kết hợp giữa các động tác thể dục và những bước nhảy sôi động trên nền nhạc Latin.
                Đây là hình thức vận động giúp đốt cháy năng lượng hiệu quả, cải thiện vóc dáng, tăng sức bền
                và mang lại tinh thần vui vẻ, hứng khởi sau mỗi buổi tập.
            </p>
        </div>

        <div class="zumba-intro-image">
            <img
                    src="${pageContext.request.contextPath}/images/zumba-main.png"
                    alt="Lớp học Zumba"
            >
        </div>
    </section>

    <!-- Thông số -->
    <section class="zumba-info-section">
        <div class="zumba-info-grid">
            <div class="zumba-info-card">
                <img src="${pageContext.request.contextPath}/images/icon-time.png" alt="Thời lượng">
                <h3>THỜI LƯỢNG</h3>
                <p>60 phút</p>
            </div>

            <div class="zumba-info-card">
                <img src="${pageContext.request.contextPath}/images/icon-fire.png" alt="Calories">
                <h3>CALORIES</h3>
                <p>250 - 600</p>
            </div>

            <div class="zumba-info-card">
                <img src="${pageContext.request.contextPath}/images/icon-location.png" alt="Địa chỉ">
                <h3>ĐỊA CHỈ</h3>
                <p>Hà Đông</p>
            </div>

            <div class="zumba-info-card">
                <img src="${pageContext.request.contextPath}/images/icon-skill.png" alt="Kỹ năng">
                <h3>KỸ NĂNG</h3>
                <p>Dành cho mọi người</p>
            </div>
        </div>
    </section>

    <!-- Lợi ích -->
    <section class="zumba-benefits-section">
        <div class="zumba-benefits-header">
            <img
                    src="${pageContext.request.contextPath}/images/zumba-benefit-banner.png"
                    alt="Zumba benefit"
                    class="zumba-benefits-banner"
            >
            <p class="zumba-benefits-description">
                Zumba không chỉ là một lớp học nhảy, mà còn là giải pháp giúp cơ thể khỏe mạnh, dẻo dai,
                tăng cường sức bền và mang lại nguồn năng lượng tích cực mỗi ngày.
            </p>
        </div>

        <div class="zumba-benefits-grid">
            <article class="benefit-card">
                <img src="${pageContext.request.contextPath}/images/icon-strength.svg" alt="Sức mạnh">
                <h3>TĂNG CƯỜNG SỨC MẠNH</h3>
                <p>
                    Các bài tập cường độ vừa và cao giúp cải thiện sức bền cơ bắp, tăng khả năng vận động
                    và hỗ trợ đốt cháy mỡ thừa hiệu quả.
                </p>
            </article>

            <article class="benefit-card">
                <img src="${pageContext.request.contextPath}/images/icon-flexibility.svg" alt="Dẻo dai">
                <h3>CƠ BẮP DẺO DAI</h3>
                <p>
                    Những chuyển động liên tục trong Zumba giúp cơ thể linh hoạt hơn, cải thiện độ dẻo
                    và tăng khả năng phối hợp toàn thân.
                </p>
            </article>

            <article class="benefit-card">
                <img src="${pageContext.request.contextPath}/images/icon-balance.svg" alt="Vững chãi">
                <h3>CƠ THỂ VỮNG CHÃI</h3>
                <p>
                    Luyện tập đều đặn giúp tăng khả năng giữ thăng bằng, củng cố nhóm cơ trung tâm
                    và cải thiện tư thế vận động.
                </p>
            </article>

            <article class="benefit-card">
                <img src="${pageContext.request.contextPath}/images/icon-endurance.svg" alt="Bền bỉ">
                <h3>SỨC KHỎE BỀN BỈ</h3>
                <p>
                    Các bài tập theo nhịp điệu giúp nâng cao sức khỏe tim mạch, cải thiện hô hấp
                    và tăng độ bền cho cơ thể trong cuộc sống hàng ngày.
                </p>
            </article>
        </div>
    </section>

    <jsp:include page="/components/formtuvan.jsp" />
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>