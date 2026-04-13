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
                    <h1>Đăng ký tập thử</h1>
                    <p>Quản lý và cập nhật trạng thái khách đăng ký tập thử</p>
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
                    <div class="filter-group filter-group-grow">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Họ tên / SĐT / email">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" ${status=='PENDING'?'selected':''}>Chờ xử lý</option>
                            <option value="CONTACTED" ${status=='CONTACTED'?'selected':''}>Đã liên hệ</option>
                            <option value="DONE" ${status=='DONE'?'selected':''}>Hoàn thành</option>
                            <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>Đã hủy</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <input type="date" name="preferredDate" value="${preferredDate}">
                    </div>

                    <button class="btn-secondary">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        Tìm kiếm
                    </button>

                    <a href="${pageContext.request.contextPath}/receptionist/trials" class="btn-light">
                        <i class="fa-solid fa-rotate-right"></i>
                        Reset
                    </a>
                </form>

                <div class="table-responsive">
                    <table class="dashboard-table">
                        <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Ngày mong muốn</th>
                            <th>Ghi chú</th>
                            <th>Trạng thái</th>
                            <th>Cập nhật</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty trialPage.content}">
                                <c:forEach var="item" items="${trialPage.content}">
                                    <tr>
                                        <td>${item.fullname}</td>
                                        <td>${item.phone}</td>
                                        <td>${item.email}</td>
                                        <td>${item.preferredDate}</td>
                                        <td>${empty item.note ? '---' : item.note}</td>

                                        <td>
                                            <span class="status-badge ${item.status.toLowerCase()}">
                                                <c:choose>
                                                    <c:when test="${item.status=='PENDING'}">Chờ xử lý</c:when>
                                                    <c:when test="${item.status=='CONTACTED'}">Đã liên hệ</c:when>
                                                    <c:when test="${item.status=='DONE'}">Hoàn thành</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <td>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/receptionist/trials/update-status/${item.trialId}"
                                                  class="inline-form">

                                                <select name="status">
                                                    <option value="PENDING" ${item.status=='PENDING'?'selected':''}>Chờ xử lý</option>
                                                    <option value="CONTACTED" ${item.status=='CONTACTED'?'selected':''}>Đã liên hệ</option>
                                                    <option value="DONE" ${item.status=='DONE'?'selected':''}>Hoàn thành</option>
                                                    <option value="CANCELLED" ${item.status=='CANCELLED'?'selected':''}>Hủy</option>
                                                </select>

                                                <button class="btn-sm btn-primary">
                                                    <i class="fa-solid fa-floppy-disk"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="empty-cell">Không có dữ liệu</td>
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