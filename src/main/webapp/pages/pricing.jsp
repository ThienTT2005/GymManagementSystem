<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PTIT Gym - Chính sách giá</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pricing.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="pricing-page">
    <!-- Banner -->
    <section class="pricing-banner">
        <img
                src="${pageContext.request.contextPath}/images/banner-pricing.png"
                alt="Chính sách giá"
                class="pricing-banner-image"
        >
        <h1 class="pricing-banner-title">CHÍNH SÁCH GIÁ</h1>
    </section>

    <!-- Bảng giá -->
    <section class="pricing-section">
        <div class="pricing-content">
            <div class="pricing-tabs">
                <button type="button" class="pricing-tab active">CLASSIC</button>
                <button type="button" class="pricing-tab">CLASSIC-PLUS</button>
                <button type="button" class="pricing-tab">PREMIUM</button>
                <button type="button" class="pricing-tab">SIGNATURE</button>
            </div>

            <div class="pricing-main">
                <div class="pricing-duration">
                    <ul class="duration-list">
                        <li class="active">24 THÁNG</li>
                        <li>12 THÁNG</li>
                        <li>6 THÁNG</li>
                        <li>3 THÁNG</li>
                        <li>1 THÁNG</li>
                    </ul>
                </div>

                <div class="pricing-divider"></div>

                <div class="pricing-info">
                    <ul>
                        <li>
                            <span>Thời gian tập luyện:</span>
                            <strong>24 tháng</strong>
                        </li>
                        <li>
                            <span>Tổng chi phí:</span>
                            <strong>15,370,000 VNĐ</strong>
                        </li>
                        <li>
                            <span>Chi phí / tháng:</span>
                            <strong>640,417 VNĐ</strong>
                        </li>
                        <li>
                            <span>Chi phí / ngày:</span>
                            <strong>21,347 VNĐ</strong>
                        </li>
                    </ul>
                </div>

                <div class="pricing-figure">
                    <img
                            src="${pageContext.request.contextPath}/images/pricing-man.png"
                            alt="Huấn luyện"
                    >
                </div>
            </div>
        </div>
    </section>

    <!-- Form đăng ký -->
    <!-- Form đăng ký -->
    <jsp:include page="/components/formtuvan.jsp" />

</body>
</html>