<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PTIT Gym - Liên hệ</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="contact-page">
    <!-- Banner -->
    <section class="contact-banner">
        <img
                src="${pageContext.request.contextPath}/images/contact-banner.png"
                alt="Liên hệ"
                class="contact-banner-image"
        >
        <h1 class="contact-banner-title">LIÊN HỆ</h1>
    </section>

    <!-- Nội dung liên hệ -->
  <section class="contact-section">
    <h2 class="contact-section-title">LIÊN HỆ CHÚNG TÔI</h2>

    <div class="contact-layout">
        <!-- MAP -->
        <div class="contact-left">
            <div class="contact-map-container">
                <iframe
                    src="https://www.google.com/maps?q=112%20Tran%20Phu,%20Mo%20Lao,%20Ha%20Dong,%20Ha%20Noi&output=embed"
                    loading="lazy">
                </iframe>
            </div>
        </div>

        <!-- FORM -->
        <div class="contact-right">
            <form class="contact-form" id="contactForm">
                <input type="text" name="fullName" placeholder="Họ và tên" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="tel" name="phone" placeholder="Số điện thoại" required>
                <textarea name="message" placeholder="Bạn có thắc mắc gì về chúng tôi không" required></textarea>
                <button type="submit" class="contact-btn">GỬI</button>
                <p id="successMessage" class="success-message">Chúng tôi sẽ phản hồi bạn sớm nhất.</p>
            </form>
        </div>

        <!-- ĐỊA CHỈ -->
        <div class="branch-info">
            <h3>CHI NHÁNH TẠI HÀ NỘI</h3>
            <p class="branch-name">CODEGYM HÀ ĐÔNG</p>
            <p>Tòa nhà Ellipse số 112 Trần Phú, Mộ Lao, Hà Đông</p>
            <p>0987 523 311</p>
            <p>codegymhadong20@gmail.com</p>
        </div>

        <!-- ẢNH RUNNER -->
        <div class="contact-runner">
            <img src="${pageContext.request.contextPath}/images/contact-runner.png" alt="Runner">
        </div>
    </div>
</section>
</main>

<jsp:include page="/components/footer.jsp" />

<script>
    const contactForm = document.getElementById("contactForm");
    const successMessage = document.getElementById("successMessage");

    contactForm.addEventListener("submit", function (e) {
        e.preventDefault();

        if (contactForm.checkValidity()) {
            successMessage.style.display = "block";
            contactForm.reset();
        } else {
            contactForm.reportValidity();
        }
    });
</script>

</body>
</html>