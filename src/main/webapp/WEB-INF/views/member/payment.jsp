<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | Gym Member</title>
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

            <h2 class="mb-4"><i class="bi bi-credit-card me-2"></i>Thanh toán</h2>

            <!-- THÔNG BÁO -->
            <c:if test="${not empty membership && membership.status != 'ACTIVE'}">
                <c:if test="${param.isNew == '1'}">
                    <div class="alert alert-success">
                        Đăng ký gói tập thành công! Vui lòng thanh toán.
                    </div>
                </c:if>
                <c:if test="${param.isNew == '0'}">
                    <div class="alert alert-success">
                        Gia hạn gói tập thành công! Vui lòng thanh toán.
                    </div>
                </c:if>
            </c:if>

            <div class="row g-4">

                <!-- THÔNG TIN THANH TOÁN -->
                <div class="col-md-5">
                    <div class="card border-0 shadow-sm h-100">

                        <div class="card-header bg-white border-0 pt-3">
                            <h5><i class="bi bi-bank me-2"></i>Thông tin thanh toán</h5>

                            <span class="badge fs-6
                            ${payment.status == 'PAID' ? 'bg-success' :
                              payment.status == 'PENDING' ? 'bg-warning text-dark' :
                              'bg-danger'}">

                            <c:choose>
                                <c:when test="${payment.status == 'PAID'}">Đã thanh toán</c:when>
                                <c:when test="${payment.status == 'PENDING'}">Chờ duyệt</c:when>
                                <c:otherwise>Từ chối</c:otherwise>
                            </c:choose>

                        </span>
                        </div>

                        <div class="card-body">

                            <div class="mb-3 p-3 bg-light rounded">
                                <p><strong>Ngân hàng:</strong> Vietcombank</p>
                                <p><strong>Số TK:</strong> 1234567890</p>
                                <p><strong>Chủ TK:</strong> CÔNG TY GYM PRO</p>

                                <p>
                                    <strong>Nội dung:</strong>

                                    <c:if test="${not empty membership}">
                                        <code>GYM-MEM-${membership.membershipId}</code>
                                    </c:if>

                                    <c:if test="${not empty classRegistration}">
                                        <code>GYM-CLASS-${classRegistration.registrationId}</code>
                                    </c:if>
                                </p>
                            </div>

                            <table class="table small">

                                <!-- GÓI -->
                                <c:if test="${not empty membership}">
                                    <tr>
                                        <td>Gói tập</td>
                                        <td class="fw-bold">
                                                ${membership.gymPackage.packageName}
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Thời hạn</td>
                                        <td>
                                                ${membership.gymPackage.durationMonths} tháng
                                        </td>
                                    </tr>
                                </c:if>

                                <!-- LỚP -->
                                <c:if test="${not empty classRegistration}">
                                    <tr>
                                        <td>Lớp</td>
                                        <td class="fw-bold">
                                                ${classRegistration.gymClass.className}
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Ngày bắt đầu</td>
                                        <td>${classRegistration.startDate}</td>
                                    </tr>
                                </c:if>

                                <!-- TIỀN -->
                                <tr>
                                    <td>Số tiền</td>
                                    <td class="fw-bold text-primary fs-5">

                                        <c:if test="${not empty membership}">
                                            <fmt:formatNumber value="${membership.gymPackage.price}" groupingUsed="true"/>đ
                                        </c:if>

                                        <c:if test="${not empty classRegistration}">
                                            <fmt:formatNumber value="${classRegistration.service.price}" groupingUsed="true"/>đ
                                        </c:if>

                                    </td>
                                </tr>

                                <tr>
                                    <td>Ngày</td>
                                    <td>${payment.paymentDate}</td>
                                </tr>

                            </table>
                        </div>
                    </div>
                </div>

                <!-- UPLOAD -->
                <c:if test="${payment.status != 'PAID'}">
                    <div class="col-md-7">

                        <div class="card border-0 shadow-sm">
                            <div class="card-body">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/member/upload-proof"
                                      enctype="multipart/form-data">

                                    <c:if test="${not empty membership}">
                                        <input type="hidden" name="membershipId" value="${membership.membershipId}">
                                    </c:if>

                                    <c:if test="${not empty classRegistration}">
                                        <input type="hidden" name="classRegistrationId" value="${classRegistration.registrationId}">
                                    </c:if>

                                    <input type="file" name="proofImage" class="form-control mb-3" required>

                                    <button class="btn btn-primary">
                                        Upload minh chứng
                                    </button>
                                </form>

                            </div>
                        </div>

                        <c:if test="${not empty payment.proofImage}">
                            <div class="mt-3">
                                <img src="<c:url value='${payment.proofImage}'/>"
                                     class="img-thumbnail"
                                     style="max-height:200px;">
                            </div>
                        </c:if>

                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
</body>
</html>
