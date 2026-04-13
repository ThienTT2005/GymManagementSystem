<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận đăng ký | Gym Member</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/member_navbar.jsp"/>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/views/common/member_sidebar.jsp"/>
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

            <nav class="mb-4">
                <a href="${pageContext.request.contextPath}/member/packages">← Quay lại</a>
            </nav>

            <div class="row justify-content-center">
                <div class="col-md-6">

                    <div class="card shadow">

                        <div class="card-header bg-primary text-white text-center">
                            Xác nhận đăng ký
                        </div>

                        <div class="card-body">

                            <c:choose>

                                <c:when test="${not empty selectedPackage}">

                                    <table class="table">

                                        <tr>
                                            <td>Gói</td>
                                            <td class="fw-bold">
                                                    ${selectedPackage.packageName}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Thời hạn</td>
                                            <td>
                                                    ${selectedPackage.durationMonths} tháng
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>Giá</td>
                                            <td class="fw-bold text-primary">
                                                <fmt:formatNumber value="${selectedPackage.price}" groupingUsed="true"/>đ
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>Mô tả</td>
                                            <td>${selectedPackage.description}</td>
                                        </tr>

                                    </table>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/member/register-package">

                                        <input type="hidden" name="packageId" value="${selectedPackage.packageId}">
                                        <input type="hidden" name="action" value="register">

                                        <button class="btn btn-primary w-100">
                                            Xác nhận đăng ký
                                        </button>
                                    </form>

                                </c:when>

                                <c:otherwise>
                                    <p>Không tìm thấy gói</p>
                                </c:otherwise>

                            </c:choose>

                        </div>

                    </div>

                </div>
            </div>

        </main>
    </div>

</div>

</body>
</html>
