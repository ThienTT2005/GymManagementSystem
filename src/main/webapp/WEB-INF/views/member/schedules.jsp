<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch tập | Gym Member</title>
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

            <h2 class="mb-4"><i class="bi bi-calendar3 me-2"></i>Lịch tập</h2>

            <a href="${pageContext.request.contextPath}/member/classes"
               class="btn btn-primary mb-3">
                <i class="bi bi-plus-circle me-1"></i>Đăng ký lớp mới
            </a>

            <!-- TABLE -->
            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">

                    <c:choose>

                        <c:when test="${empty myClasses}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
                                <p class="text-muted">Bạn chưa đăng ký lớp học nào.</p>
                                <a href="${pageContext.request.contextPath}/member/classes"
                                   class="btn btn-primary">
                                    Xem danh sách lớp
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">

                                    <thead class="table-dark">
                                    <tr>
                                        <th>#</th>
                                        <th>Lớp học</th>
                                        <th>Dịch vụ</th>
                                        <th>Huấn luyện viên</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                    </thead>

                                    <tbody>

                                    <c:forEach var="cr" items="${myClasses}" varStatus="st">
                                        <tr>

                                            <td>${st.count}</td>

                                            <!-- CLASS -->
                                            <td>
                                                <strong>${cr.gymClass.className}</strong>
                                            </td>

                                            <!-- SERVICE -->
                                            <td>
                                                    ${cr.gymClass.service.serviceName}
                                            </td>

                                            <!-- TRAINER -->
                                            <td>
                                                    ${cr.gymClass.trainerName}
                                            </td>

                                            <!-- START DATE -->
                                            <td>
                                                    ${cr.startDate}
                                            </td>

                                            <!-- STATUS -->
                                            <td>
                                            <span class="badge
                                                ${cr.status == 'ACTIVE' ? 'bg-success' :
                                                  cr.status == 'PENDING' ? 'bg-warning text-dark' :
                                                  'bg-secondary'}">
                                                    ${cr.status}
                                            </span>
                                            </td>

                                            <!-- ACTION -->
                                            <td>
                                                <a href="${pageContext.request.contextPath}/member/class-schedule?classId=${cr.gymClass.classId}"
                                                   class="btn btn-sm btn-outline-primary me-1">Xem
                                                </a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/member/cancel-class"
                                                      class="d-inline"
                                                      onsubmit="return confirm('Huỷ đăng ký lớp này?')">

                                                    <input type="hidden"
                                                           name="classRegistrationId"
                                                           value="${cr.registrationId}">

                                                    <button type="submit"
                                                            class="btn btn-sm btn-outline-danger">
                                                        Huỷ
                                                    </button>
                                                </form>
                                            </td>

                                        </tr>
                                    </c:forEach>

                                    </tbody>

                                </table>
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>
            </div>

        </main>
    </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
