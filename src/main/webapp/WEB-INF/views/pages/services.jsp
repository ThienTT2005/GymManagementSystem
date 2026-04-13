<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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

<main class="services-page page-transition-main">
    <section class="services-banner">
        <img src="${pageContext.request.contextPath}/images/banner.png"
             alt="Dịch vụ"
             class="services-banner-img">
        <h1 class="services-banner-title">DỊCH VỤ</h1>
    </section>

    <section class="services-intro">
        <h2 class="section-title">CÁC DỊCH VỤ CỦA CHÚNG TÔI</h2>
        <p class="section-description">
            Các chương trình luyện tập được thiết kế một cách khoa học và phù hợp bởi các chuyên gia, sẽ hỗ trợ bạn
            trong việc đạt được mục tiêu về sức khỏe và hình thể.
        </p>
    </section>

    <section class="services-list">
        <c:choose>
            <c:when test="${not empty services}">
                <c:forEach var="service" items="${services}">
                    <a href="${pageContext.request.contextPath}/services/${service.serviceId}"
                       style="text-decoration: none; color: inherit; display: block;">
                        <article class="service-card">
                            <c:choose>
                                <c:when test="${empty service.image}">
                                    <img src="${pageContext.request.contextPath}/assets/images/default-service.png"
                                         alt="<c:out value='${service.serviceName}'/>"
                                         class="service-card-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/uploads/${service.image}"
                                         alt="<c:out value='${service.serviceName}'/>"
                                         class="service-card-image">
                                </c:otherwise>
                            </c:choose>

                            <div class="service-card-content">
                                <h3 class="service-card-title">
                                    <c:out value="${service.serviceName}" />
                                </h3>

                                <div class="service-card-meta">
                                    <c:choose>
                                        <c:when test="${service.price != null && service.price > 0}">
                                            <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" /> VNĐ
                                        </c:when>
                                        <c:otherwise>
                                            Liên hệ
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <p class="service-card-description">
                                    <c:choose>
                                        <c:when test="${not empty service.description and fn:length(service.description) > 100}">
                                            <c:out value="${fn:substring(service.description, 0, 100)}" />...
                                        </c:when>
                                        <c:when test="${not empty service.description}">
                                            <c:out value="${service.description}" />
                                        </c:when>
                                        <c:otherwise>
                                            Mô tả đang được cập nhật...
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </article>
                    </a>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <div style="text-align: center; font-size: 18px; color: #555; grid-column: 1 / -1; padding: 40px;">
                    Hệ thống đang cập nhật các dịch vụ. Vui lòng quay lại sau!
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <h2 class="consult-form-title">ĐĂNG KÝ VÀ NHẬN TƯ VẤN</h2>
    <div class="services-consult-below">
        <jsp:include page="/components/formtuvan.jsp" />
    </div>
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>