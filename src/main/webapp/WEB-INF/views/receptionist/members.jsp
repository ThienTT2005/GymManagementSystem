<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách hội viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-topbar">
                <h2 class="page-title">Danh sách hội viên</h2>
                <a href="${pageContext.request.contextPath}/receptionist/create-member" class="add-btn">
                    <i class="fa-solid fa-plus"></i><span>Thêm hội viên</span>
                </a>
            </div>

            <div class="list-card">
                <div class="list-toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/receptionist/members" class="search-form multi-search-form">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên, SĐT, email">
                        </div>

                        <select name="packageFilter" class="filter-select">
                            <option value="">Tất cả gói tập</option>
                            <c:forEach var="pkg" items="${packageOptions}">
                                <option value="${pkg}" ${packageFilter eq pkg ? 'selected' : ''}>${pkg}</option>
                            </c:forEach>
                        </select>

                        <select name="serviceFilter" class="filter-select">
                            <option value="">Tất cả dịch vụ</option>
                            <c:forEach var="srv" items="${serviceOptions}">
                                <option value="${srv}" ${serviceFilter eq srv ? 'selected' : ''}>${srv}</option>
                            </c:forEach>
                        </select>

                        <button type="submit" class="filter-btn">Lọc</button>
                    </form>
                </div>

                <div class="table-wrap">
                    <table class="member-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Giới tính</th>
                            <th>Gói tập</th>
                            <th>Dịch vụ</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty members}">
                                <c:forEach var="m" items="${members}">
                                    <tr>
                                        <td>${m.memberId}</td>
                                        <td>${m.fullname}</td>
                                        <td>${m.phone}</td>
                                        <td>${m.email}</td>
                                        <td>${m.gender}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${memberPackageMap[m.memberId] != '--'}">
                                                    <span class="package-badge premium">${memberPackageMap[m.memberId]}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="null-text">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="service-column">
                                            <c:set var="servicesText" value="${memberServicesTextMap[m.memberId]}"/>
                                            <c:choose>
                                                <c:when test="${not empty servicesText and servicesText != '--'}">
                                                    <span class="service-list-text" title="${servicesText}">
                                                        ${fn:length(servicesText) > 22 ? fn:substring(servicesText, 0, 22).concat('...') : servicesText}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="null-text">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/receptionist/member-detail?id=${m.memberId}" class="action-btn view-btn">
                                                    <i class="fa-regular fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/receptionist/edit-member?id=${m.memberId}" class="action-btn edit-btn">
                                                    <i class="fa-regular fa-pen-to-square"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-row">Chưa có dữ liệu hội viên</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-box">
                    <c:if test="${page > 1}">
                        <a class="page-btn"
                           href="?keyword=${keyword}&packageFilter=${packageFilter}&serviceFilter=${serviceFilter}&page=${page - 1}">&laquo;</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a class="page-btn ${i == page ? 'active' : ''}"
                           href="?keyword=${keyword}&packageFilter=${packageFilter}&serviceFilter=${serviceFilter}&page=${i}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${page < totalPages}">
                        <a class="page-btn"
                           href="?keyword=${keyword}&packageFilter=${packageFilter}&serviceFilter=${serviceFilter}&page=${page + 1}">&raquo;</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>