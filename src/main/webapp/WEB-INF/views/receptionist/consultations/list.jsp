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
                    <h1>Yêu cầu tư vấn</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">

                <form method="get" class="filter-form">
                    <div class="filter-group search-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="NEW" ${status=='NEW'?'selected':''}>Chờ liên hệ</option>
                            <option value="CONTACTED" ${status=='CONTACTED'?'selected':''}>Đã liên hệ</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-search"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light"
                           href="${pageContext.request.contextPath}/receptionist/consultations">
                            <i class="fa-solid fa-rotate-right"></i>
                            <span>Reset</span>
                        </a>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Nội dung</th>
                            <th>Trạng thái</th>
                            <th>Cập nhật</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty consultationPage.content}">
                                <c:forEach var="item" items="${consultationPage.content}">
                                    <tr>
                                        <td>${item.fullname}</td>
                                        <td>${item.phone}</td>
                                        <td>${item.email}</td>
                                        <td>${item.message}</td>

                                        <td>
                                            <span class="status-badge ${item.status == 'CONTACTED' ? 'contacted' : 'pending'}">
                                                <c:choose>
                                                    <c:when test="${item.status=='CONTACTED'}">Đã liên hệ</c:when>
                                                    <c:otherwise>Chờ liên hệ</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <td>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/receptionist/consultations/update-status/${item.consultationId}"
                                                  class="inline-form">
                                                <input type="hidden" name="status"
                                                       value="${item.status == 'CONTACTED' ? 'NEW' : 'CONTACTED'}"/>

                                                <button class="btn-sm ${item.status == 'CONTACTED' ? 'btn-light' : 'btn-primary'}" type="submit"
                                                        title="${item.status == 'CONTACTED' ? 'Chuyển về chờ liên hệ' : 'Đánh dấu đã liên hệ'}">
                                                    <i class="fa-solid ${item.status == 'CONTACTED' ? 'fa-toggle-on' : 'fa-toggle-off'}"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">Không có dữ liệu</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>
</div>
</body>
</html>