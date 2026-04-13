<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử | Gym Member</title>
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

            <h2 class="mb-4"><i class="bi bi-clock-history me-2"></i>Lịch sử đăng ký</h2>

            <!-- TABS -->
            <ul class="nav nav-tabs mb-4">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-payment">
                        Thanh toán
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-membership">
                        Gói tập
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-class">
                        Lớp học
                    </button>
                </li>
            </ul>

            <div class="tab-content">

                <!-- PAYMENT -->
                <div class="tab-pane fade show active" id="tab-payment">
                    <table class="table table-hover">
                        <tr>
                            <th>#</th><th>Loại</th><th>Số tiền</th>
                            <th>Ngày</th><th>Trạng thái</th>
                        </tr>

                        <c:forEach var="p" items="${payments}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>

                                <td>
                                    <c:if test="${not empty p.membership}">
                                        Membership - ${p.membership.gymPackage.packageName}
                                    </c:if>

                                    <c:if test="${not empty p.classRegistration}">
                                        Class - ${p.classRegistration.gymClass.className}
                                    </c:if>
                                </td>

                                <td>
                                    <fmt:formatNumber value="${p.amount}" groupingUsed="true"/>đ
                                </td>

                                <td>${p.paymentDate}</td>

                                <td>
                                <span class="badge
                                    ${p.status == 'PAID' ? 'bg-success' :
                                      p.status == 'PENDING' ? 'bg-warning text-dark' :
                                      'bg-danger'}">
                                        ${p.status}
                                </span>
                                </td>
                            </tr>
                        </c:forEach>

                    </table>
                </div>

                <!-- MEMBERSHIP -->
                <div class="tab-pane fade" id="tab-membership">
                    <table class="table table-hover">
                        <tr>
                            <th>#</th><th>Gói</th><th>Bắt đầu</th>
                            <th>Kết thúc</th><th>Trạng thái</th>
                        </tr>

                        <c:forEach var="m" items="${memberships}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>

                                <td>
                                        ${m.gymPackage.packageName}
                                </td>

                                <td>${m.startDate}</td>
                                <td>${m.endDate}</td>

                                <td>
                                <span class="badge
                                    ${m.status == 'ACTIVE' ? 'bg-success' :
                                      m.status == 'PENDING' ? 'bg-warning text-dark' :
                                      'bg-secondary'}">
                                        ${m.status}
                                </span>
                                </td>
                            </tr>
                        </c:forEach>

                    </table>
                </div>

                <!-- CLASS -->
                <div class="tab-pane fade" id="tab-class">
                    <table class="table table-hover">
                        <tr>
                            <th>#</th><th>Lớp</th><th>HLV</th>
                            <th>Dịch vụ</th><th>Bắt đầu</th><th>Kết thúc</th><th>Trạng thái</th>
                        </tr>

                        <c:forEach var="cr" items="${classRegistrations}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>

                                <td>${cr.gymClass.className}</td>

                                <td>${cr.gymClass.trainerName}</td>

                                <td>${cr.gymClass.service.serviceName}</td>

                                <td>${cr.startDate}</td>
                                <td>${cr.endDate}</td>

                                <td>
                                <span class="badge
                                    ${cr.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        ${cr.status}
                                </span>
                                </td>
                            </tr>
                        </c:forEach>

                    </table>
                </div>

            </div>

        </main>
    </div>

</div>

</body>
</html>
