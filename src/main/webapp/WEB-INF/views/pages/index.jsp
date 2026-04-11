<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CODEGYM</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/news.css?v=1">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<section class="banner">
    <img src="${pageContext.request.contextPath}/images/banner.jpg" alt="Banner">
</section>

<section class="clubs-section">
    <h2>CÂU LẠC BỘ Ở GẦN BẠN</h2>
    <p>
        Khám phá hệ thống phòng tập CODEGYM hiện đại, đa dạng, đáp ứng mọi nhu cầu tập luyện của bạn,
        dù bạn ở bất kỳ đâu tại Hà Nội.
    </p>

    <div class="grid">
        <a href="${pageContext.request.contextPath}/pages/services/zumba.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/zumba-8.png" alt="Zumba">
            <div class="overlay">ZUMBA</div>
        </a>

        <a href="${pageContext.request.contextPath}/pages/services/bodycombat.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/bodycombat.png" alt="Body Combat">
            <div class="overlay">BODY COMBAT</div>
        </a>

        <a href="${pageContext.request.contextPath}/pages/services/bodypump.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/bodypump-8.png" alt="Body Pump">
            <div class="overlay">BODY PUMP</div>
        </a>

        <a href="${pageContext.request.contextPath}/pages/services/steptok.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/bums-tums-8.png" alt="Step Tok">
            <div class="overlay">STEP TOK</div>
        </a>

        <a href="${pageContext.request.contextPath}/pages/services/pilates.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/pilates.jpg" alt="Pilates">
            <div class="overlay">PILATES</div>
        </a>

        <a href="${pageContext.request.contextPath}/pages/services/aerobics.jsp" class="grid-item">
            <img src="${pageContext.request.contextPath}/images/aerobic-8.png" alt="Aerobics">
            <div class="overlay">AEROBICS</div>
        </a>
    </div>
</section>

<section class="promo-news-section">
    <div class="member-news-header">
        <h2>CÂU CHUYỆN HỘI VIÊN</h2>
        <p>
            Trải qua hơn 10 năm với hàng ngàn thế hệ hội viên, CODEGYM đã chứng kiến rất nhiều sự thay đổi ngoạn mục.
            <br>
            Cùng khám phá các câu chuyện "đằng sau phòng tập" của các hội viên nhé!
        </p>
    </div>

    <c:choose>
        <c:when test="${not empty memberNews.newsList}">
            <div class="promo-news-grid">
                <c:forEach var="item" items="${memberNews.newsList}">
                    <article class="promo-news-card">
                        <a href="${pageContext.request.contextPath}/news/${item.postId}">
                            <img class="promo-news-card-image"
                                 src="${pageContext.request.contextPath}${item.image}"
                                 alt="${item.title}">
                        </a>

                        <div class="promo-news-card-body">
                            <div class="promo-news-card-category">
                                <c:choose>
                                    <c:when test="${item.category == 'CAU_CHUYEN_HOI_VIEN'}">CÂU CHUYỆN HỘI VIÊN</c:when>
                                    <c:when test="${item.category == 'BLOG'}">BLOG</c:when>
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
                                ${fn:replace(item.content, '. ', '.<br/>')}
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
        <p>Để lại thông tin và chúng tôi sẽ gửi lại kết quả cho bạn trong thời gian sớm nhất!</p>

        <form id="bmiForm" class="bmi-form">
            <input type="text" name="height" placeholder="Chiều cao/ cm" required>
            <input type="text" name="weight" placeholder="Cân nặng/ kg" required>
            <input type="text" name="age" placeholder="Tuổi" required>

            <select name="gender" required>
                <option value="" disabled selected>Giới tính</option>
                <option value="Nam">Nam</option>
                <option value="Nữ">Nữ</option>
            </select>

            <input
                    type="text"
                    name="fullname"
                    placeholder="Họ và tên"
                    pattern="[A-Za-zÀ-ỹ\\s]+"
                    title="Vui lòng chỉ nhập chữ cái"
                    required
            >

            <input
                    type="text"
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

        <div id="bmiMessage" class="bmi-success-message" style="display:none;">
            Cảm ơn bạn, chúng tôi đã nhận thông tin!
        </div>
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

        track.style.transform = `translateX(-${moveX}px)`;
    }

    function updateBeforeAfter(value) {
        const afterImage = document.getElementById("baAfterImage");
        const sliderBtn = document.getElementById("sliderButton");

        if (afterImage) {
            afterImage.style.clipPath = `polygon(${value}% 0, 100% 0, 100% 100%, ${value}% 100%)`;
        }

        if (sliderBtn) {
            sliderBtn.style.left = `${value}%`;
        }
    }

    document.getElementById("bmiForm")?.addEventListener("submit", function (e) {
        e.preventDefault();
        const formData = new FormData(this);

        fetch("${pageContext.request.contextPath}/pages/saveBmi.jsp", {
            method: "POST",
            body: formData
        })
            .then(res => res.text())
            .then(data => {
                if (data.trim() === "success") {
                    document.getElementById("bmiForm").style.display = "none";
                    document.getElementById("bmiMessage").style.display = "block";
                }
            });
    });
</script>

</body>
</html>