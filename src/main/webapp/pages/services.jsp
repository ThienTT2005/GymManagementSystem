<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PTIT Gym - Dịch vụ</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/services.css">
    </head>

    <body>

        <jsp:include page="/components/header.jsp" />

        <main class="services-page">
            <section class="services-banner">
                <img src="${pageContext.request.contextPath}/images/banner.png" alt="Dịch vụ"
                    class="services-banner-img">
                <h1 class="services-banner-title">DỊCH VỤ</h1>
            </section>

            <section class="services-intro">
                <h2 class="section-title">CÁC DỊCH VỤ CỦA CHÚNG TÔI</h2>
                <p class="section-description">
                    Các chương trình luyện tập Body Combat, Body Pump, StepTok, Zumba, Aerobics
                    được thiết kế một cách khoa học và phù hợp bởi các chuyên gia, sẽ hỗ trợ bạn
                    trong việc đạt được mục tiêu về sức khỏe và hình thể.
                </p>
            </section>

            <section class="services-list">
                <a href="${pageContext.request.contextPath}/pages/services/zumba.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/zumba-8.png" alt="Zumba"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">ZUMBA</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Bộ môn kết hợp thể dục và âm nhạc sôi động, giúp cơ thể dẻo dai
                                và đốt cháy năng lượng hiệu quả.
                            </p>
                        </div>
                    </article>
                </a>

                <a href="${pageContext.request.contextPath}/pages/services/bodycombat.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/bodycombat.png" alt="BodyCombat"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">BODYCOMBAT</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Hình thức luyện tập đầy năng lượng, lấy cảm hứng từ võ thuật,
                                giúp tăng sức bền và thể lực.
                            </p>
                        </div>
                    </article>
                </a>

                <a href="${pageContext.request.contextPath}/pages/services/bodypump.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/bodypump-8.png" alt="Body Pump"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">BODY PUMP</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Lớp tập với tạ giúp cơ thể săn chắc, khỏe mạnh và hỗ trợ giảm mỡ hiệu quả.
                            </p>
                        </div>
                    </article>
                </a>

                <a href="${pageContext.request.contextPath}/pages/services/steptok.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/bums-tums-8.png" alt="Step Tok"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">STEP TOK</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Bộ môn vận động nhịp nhàng, tạo cảm giác mới mẻ và tăng độ linh hoạt cho cơ thể.
                            </p>
                        </div>
                    </article>
                </a>

                <a href="${pageContext.request.contextPath}/pages/services/pilates.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/pilates.jpg" alt="Pilates"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">PILATES</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Phương pháp luyện tập giúp cải thiện tư thế, tăng độ dẻo dai
                                và kiểm soát cơ thể tốt hơn.
                            </p>
                        </div>
                    </article>
                </a>

                <a href="${pageContext.request.contextPath}/pages/services/aerobics.jsp" style="text-decoration: none; color: inherit; display: block;">
                    <article class="service-card">
                        <img src="${pageContext.request.contextPath}/images/aerobic-8.png" alt="Aerobics"
                            class="service-card-image">
                        <div class="service-card-content">
                            <h3 class="service-card-title">AEROBICS</h3>
                            <div class="service-card-meta">60 phút</div>
                            <p class="service-card-description">
                                Bài tập sôi động giúp nâng cao sức khỏe tim mạch, đốt calo
                                và làm tinh thần thoải mái hơn.
                            </p>
                        </div>
                    </article>
                </a>
            </section>
        </main>

        <jsp:include page="/components/footer.jsp" />

    </body>

    </html>