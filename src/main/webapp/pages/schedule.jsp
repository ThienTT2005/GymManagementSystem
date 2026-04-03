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
    <jsp:include page="/components/formtuvan.jsp" />
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>