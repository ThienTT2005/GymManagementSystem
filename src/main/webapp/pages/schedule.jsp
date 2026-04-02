<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PTIT Gym - Lịch học</title>

    <!-- CSS chung nếu có -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- CSS riêng trang lịch học -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/schedule.css">
</head>
<body>

<jsp:include page="/components/header.jsp" />

<main class="schedule-page">
    <!-- Banner -->
    <section class="schedule-banner">
        <img
                src="${pageContext.request.contextPath}/images/banner.png"
                alt="Banner lịch học"
                class="schedule-banner-img"
        >
        <h1 class="schedule-banner-title">LỊCH HỌC</h1>
    </section>

    <!-- Form đăng ký -->
    <section class="schedule-form-section">
        <h2 class="schedule-form-title">CHỌN CLB VÀ ĐĂNG KÝ LỊCH HỌC</h2>

        <form class="schedule-form" id="scheduleForm">
            <div class="form-group">
                <label for="fullName">Họ và tên</label>
                <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        class="form-input"
                        required
                >
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input
                        type="tel"
                        id="phone"
                        name="phone"
                        class="form-input"
                        pattern="0[0-9]{9}"
                        required
                >
            </div>

            <div class="form-group">
                <label for="club">Chọn câu lạc bộ</label>
                <select
                        id="club"
                        name="club"
                        class="form-input"
                        required
                >
                    <option value="">-- Chọn câu lạc bộ --</option>
                    <option value="yoga">Yoga</option>
                    <option value="pilates">Pilates</option>
                    <option value="bodypump">BodyPump</option>
                    <option value="zumba">Zumba</option>
                    <option value="dance">Dance</option>
                    <option value="gym">Gym</option>
                </select>
            </div>

            <div class="form-group">
                <label for="callTime">Giờ nào tôi có thể gọi cho bạn</label>
                <input
                        type="text"
                        id="callTime"
                        name="callTime"
                        class="form-input"
                        required
                >
            </div>

            <div class="form-group form-group-full">
                <label for="sessions">Số buổi bạn muốn học trong tuần</label>
                <input
                        type="number"
                        id="sessions"
                        name="sessions"
                        class="form-input"
                        min="1"
                        max="7"
                        required
                >
            </div>

            <div class="form-submit">
                <button type="submit" class="btn-submit">ĐĂNG KÝ NGAY</button>
            </div>

            <p id="successMessage" class="success-message">
                Chúng tôi sẽ liên hệ với bạn sớm nhất
            </p>
        </form>
    </section>
</main>

<jsp:include page="/components/footer.jsp" />

<script>
    const scheduleForm = document.getElementById("scheduleForm");
    const successMessage = document.getElementById("successMessage");

    scheduleForm.addEventListener("submit", function (e) {
        e.preventDefault();

        if (scheduleForm.checkValidity()) {
            successMessage.style.display = "block";
            scheduleForm.reset();
        } else {
            scheduleForm.reportValidity();
        }
    });
</script>

</body>
</html>