<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GYM PRO</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news.css?v=1">

    <style>
        .bmi-success-message {
            display: none;
            margin-top: 20px;
            padding: 16px 20px;
            background: #f8d7da;
            color: #b30000;
            border-radius: 6px;
            font-size: 20px;
            line-height: 1.6;
        }

        .bmi-success-message.success-normal {
            background: #d4edda;
            color: #155724;
        }

        .bmi-success-message.success-warning {
            background: #fff3cd;
            color: #856404;
        }

        .bmi-success-message.success-danger {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>

<jsp:include page="/components/header.jsp" />

<section class="banner">
    <img src="${pageContext.request.contextPath}/images/banner.jpg" alt="Banner">
</section>

<section class="clubs-section home-intro-section">
    <h2>HOME</h2>
    <p>
        Chào mừng bạn đến với không gian luyện tập GYM PRO. Khám phá các dịch vụ dưới đây và chọn chương trình
        phù hợp với mục tiêu sức khỏe của bạn.
    </p>

    <div class="grid">
        <c:choose>
            <c:when test="${not empty services}">
                <c:forEach var="service" items="${services}" varStatus="status" end="8">
                    <a href="${pageContext.request.contextPath}/services/${service.serviceId}" class="grid-item" style="position: relative; display: block; overflow: hidden;">
                        <c:choose>
                            <c:when test="${not empty service.image}">
                                <img src="${pageContext.request.contextPath}/uploads/${service.image}"
                                     alt="<c:out value='${service.serviceName}' />"
                                     style="width: 100%; height: 100%; object-fit: cover; display: block; filter: brightness(40%); transition: filter 0.3s;"
                                     onmouseover="this.style.filter='brightness(60%)'"
                                     onmouseout="this.style.filter='brightness(40%)'">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-service.png"
                                     alt="<c:out value='${service.serviceName}' />"
                                     style="width: 100%; height: 100%; object-fit: cover; display: block; filter: brightness(40%); transition: filter 0.3s;"
                                     onmouseover="this.style.filter='brightness(60%)'"
                                     onmouseout="this.style.filter='brightness(40%)'">
                            </c:otherwise>
                        </c:choose>
                        <div class="overlay" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: white; font-size: 28px; font-weight: bold; text-align: center; text-transform: uppercase; pointer-events: none; width: 100%;">
                            <c:out value="${service.serviceName}" />
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="text-align:center; padding: 20px; color: #666; grid-column: 1 / -1;">
                    Hiện chưa có dịch vụ nào trực tuyến.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<section class="promo-news-section">
    <div class="member-news-header">
        <h2>CÂU CHUYỆN HỘI VIÊN</h2>
        <p>
            Trải qua hơn 10 năm với hàng ngàn thế hệ hội viên, GYM PRO đã chứng kiến rất nhiều sự thay đổi ngoạn mục.
            <br>
            Cùng khám phá các câu chuyện "đằng sau phòng tập" của các hội viên nhé!
        </p>
    </div>

    <c:choose>
        <c:when test="${not empty memberNews}">
            <div class="promo-news-grid">
                <c:forEach var="item" items="${memberNews}">
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
                                    <c:when test="${item.category == 'STORY'}">CÂU CHUYỆN HỘI VIÊN</c:when>
                                    <c:when test="${item.category == 'BLOG'}">BLOG</c:when>
                                    <c:when test="${item.category == 'PROMOTION'}">KHUYẾN MÃI</c:when>
                                    <c:when test="${item.category == 'NEWS'}">TIN MỚI</c:when>
                                    <c:otherwise>${item.category}</c:otherwise>
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

<section class="before-after-section">
    <div class="ba-text">
        <h2>BEFORE & AFTER</h2>
        <p>
            Tập luyện chăm chỉ là yếu tố then chốt để có một
            <br>
            thân hình đẹp, nhưng không phải là yếu tố duy nhất.
        </p>
    </div>

    <div class="ba-slider-container">
        <div class="ba-images">
            <img src="${pageContext.request.contextPath}/images/before.png" alt="Before" class="ba-before">
            <img src="${pageContext.request.contextPath}/images/after.png" alt="After" class="ba-after" id="baAfterImage">
        </div>

        <input
                type="range"
                min="0"
                max="100"
                value="50"
                class="ba-slider"
                id="baSlider"
                oninput="updateBeforeAfter(this.value)"
        >
        <div class="slider-button" id="sliderButton"></div>
    </div>
</section>

<section class="bmi-section">
    <div class="bmi-image">
        <img src="${pageContext.request.contextPath}/images/run.png" alt="Run">
    </div>

    <div class="bmi-content">
        <h2>TÍNH BMI (CHỈ SỐ KHỐI CƠ THỂ)</h2>
        <p>Nhập thông tin để xem ngay chỉ số BMI của bạn.</p>

        <form id="bmiForm" class="bmi-form">
            <input type="number" id="height" name="height" placeholder="Chiều cao / cm" min="1" step="0.1" required>
            <input type="number" id="weight" name="weight" placeholder="Cân nặng / kg" min="1" step="0.1" required>
            <input type="number" id="age" name="age" placeholder="Tuổi" min="1" required>

            <select id="gender" name="gender" required>
                <option value="" disabled selected>Giới tính</option>
                <option value="Nam">Nam</option>
                <option value="Nữ">Nữ</option>
            </select>

            <input
                    type="text"
                    id="fullname"
                    name="fullname"
                    placeholder="Họ và tên"
                    pattern="^[A-Za-zÀ-ỹ]+(\s[A-Za-zÀ-ỹ]+)*$"
                    title="Chỉ được nhập chữ cái và khoảng trắng, không chứa số"
                    required
            >

            <input
                    type="text"
                    id="phone"
                    name="phone"
                    placeholder="Số điện thoại"
                    pattern="[0-9]{10}"
                    title="Vui lòng nhập đúng 10 số"
                    required
            >

            <div class="bmi-submit">
                <button type="submit">Nhận kết quả</button>
            </div>
        </form>

        <div id="bmiMessage" class="bmi-success-message"></div>
    </div>
</section>

<jsp:include page="/components/footer.jsp" />

<script>
    let currentSlide = 0;
    const visibleSlides = 3;

    function moveSlide(direction) {
        const track = document.getElementById("newsSlider");
        const slides = document.querySelectorAll("#newsSlider .promo-news-card");
        const totalSlides = slides.length;

        if (!track || totalSlides === 0) return;

        currentSlide += direction;

        const maxSlide = Math.max(0, totalSlides - visibleSlides);

        if (currentSlide < 0) {
            currentSlide = 0;
        }

        if (currentSlide > maxSlide) {
            currentSlide = maxSlide;
        }

        const slideWidth = slides[0].offsetWidth;
        const gap = 24;
        const moveX = currentSlide * (slideWidth + gap);

        track.style.transform = "translateX(-" + moveX + "px)";
    }

    function updateBeforeAfter(value) {
        const afterImage = document.getElementById("baAfterImage");
        const sliderBtn = document.getElementById("sliderButton");

        if (afterImage) {
            afterImage.style.clipPath = "polygon(" + value + "% 0, 100% 0, 100% 100%, " + value + "% 100%)";
        }

        if (sliderBtn) {
            sliderBtn.style.left = value + "%";
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const bmiForm = document.getElementById("bmiForm");
        const bmiMessage = document.getElementById("bmiMessage");

        if (!bmiForm || !bmiMessage) return;

        bmiForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const fullName = document.getElementById("fullname").value.trim();
            const height = parseFloat(document.getElementById("height").value);
            const weight = parseFloat(document.getElementById("weight").value);

            const nameRegex = /^[A-Za-zÀ-ỹ]+(\s[A-Za-zÀ-ỹ]+)*$/;""

            if (fullName === "") {
                alert("Vui lòng nhập họ và tên.");
                return;
            }

            if (!nameRegex.test(fullName)) {
                alert("Họ tên không được chứa số hoặc ký tự đặc biệt.");
                return;
            }

            if (isNaN(height) || height <= 0) {
                alert("Chiều cao không hợp lệ.");
                return;
            }

            if (isNaN(weight) || weight <= 0) {
                alert("Cân nặng không hợp lệ.");
                return;
            }

            const heightM = height / 100;
            const bmi = weight / (heightM * heightM);

            let classification = "";
            let className = "bmi-success-message ";

            if (bmi < 18.5) {
                classification = "Thiếu cân";
                className += "success-warning";
            } else if (bmi < 25) {
                classification = "Bình thường";
                className += "success-normal";
            } else if (bmi < 30) {
                classification = "Thừa cân";
                className += "success-warning";
            } else {
                classification = "Béo phì";
                className += "success-danger";
            }

            bmiMessage.className = className;
            bmiMessage.innerHTML =
                "Chào <strong>" + fullName + "</strong>, chỉ số BMI của bạn là <strong>" +
                bmi.toFixed(2) + "</strong> - <strong>" + classification + "</strong>.";
            bmiMessage.style.display = "block";
        });
    });
</script>

</body>
</html>