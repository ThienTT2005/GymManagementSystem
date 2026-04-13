<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ttt.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Đăng ký lớp học</h1>
                </div>

                <a class="btn-primary"
                   href="${pageContext.request.contextPath}/receptionist/class-registrations/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm đăng ký</span>
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/receptionist/class-registrations"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm hội viên">
                    </div>

                    <div class="filter-group">
                        <select name="classId">
                            <option value="">Tất cả lớp</option>
                            <c:forEach var="c" items="${classes}">
                                <option value="${c.classId}" ${classId==c.classId?'selected':''}>
                                    ${c.className}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" ${status=='PENDING'?'selected':''}>Chờ xử lý</option>
                            <option value="ACTIVE" ${status=='ACTIVE'?'selected':''}>Hoạt động</option>
                            <option value="REJECTED" ${status=='REJECTED'?'selected':''}>Từ chối</option>
                            <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>Đã hủy</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-search"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light"
                           href="${pageContext.request.contextPath}/receptionist/class-registrations">
                            <i class="fa-solid fa-rotate-right"></i>
                            <span>Reset</span>
                        </a>
                    </div>
                </form>
            </div>

            <div class="page-card">
                <div class="table-responsive">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hội viên</th>
                            <th>Lớp</th>
                            <th>Dịch vụ</th>
                            <th>Ngày đăng ký</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty registrationPage.content}">
                                <c:forEach var="item" items="${registrationPage.content}" varStatus="loop">
                                    <tr>
                                        <td>${registrationPage.number * registrationPage.size + loop.index + 1}</td>
                                        <td>${item.member != null ? item.member.fullname : '---'}</td>
                                        <td>${item.gymClass != null ? item.gymClass.className : '---'}</td>
                                        <td>${item.gymClass != null && item.gymClass.service != null ? item.gymClass.service.serviceName : '---'}</td>
                                        <td>${item.registrationDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${item.status == 'ACTIVE'}">Đã xác nhận</c:when>
                                                <c:otherwise>Kiểm tra tại thanh toán</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <span class="status-badge ${item.status == 'ACTIVE' ? 'active' : item.status == 'PENDING' ? 'pending' : 'inactive'}">
                                                <c:choose>
                                                    <c:when test="${item.status == 'ACTIVE'}">Hoạt động</c:when>
                                                    <c:when test="${item.status == 'PENDING'}">Chờ xử lý</c:when>
                                                    <c:when test="${item.status == 'REJECTED'}">Từ chối</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">
                                                <c:if test="${item.status == 'PENDING'}">
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/receptionist/class-registrations/approve/${item.registrationId}"
                                                          class="inline-form"
                                                          onsubmit="return confirm('Chỉ duyệt khi thanh toán đã ở trạng thái PAID. Tiếp tục?');">
                                                        <button class="btn-sm btn-approve" type="submit" title="Duyệt">
                                                            <i class="fa-solid fa-check"></i>
                                                        </button>
                                                    </form>

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/receptionist/class-registrations/reject/${item.registrationId}"
                                                          class="inline-form"
                                                          onsubmit="return confirm('Xác nhận từ chối đăng ký lớp này?');">
                                                        <button class="btn-sm btn-delete" type="submit" title="Từ chối">
                                                            <i class="fa-solid fa-xmark"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-cell">Không có đăng ký lớp phù hợp</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${registrationPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${registrationPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == registrationPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/receptionist/class-registrations?keyword=${keyword}&status=${status}&classId=${classId}&page=${p + 1}&size=${registrationPage.size}">
                                ${p + 1}
                            </a>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
</body>
</html>