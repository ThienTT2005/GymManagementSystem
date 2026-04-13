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

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>Hội viên</h1>
                </div>

                <a class="btn-primary"
                   href="${pageContext.request.contextPath}/receptionist/members/create">
                    <i class="fa-solid fa-plus"></i>
                </a>
            </div>

            <!-- FLASH -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <!-- FILTER -->
            <div class="page-card">
                <form method="get"
                      action="${pageContext.request.contextPath}/receptionist/members"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tên, SĐT">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" ${status == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${status == 0 ? 'selected' : ''}>Ngừng</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn-secondary">
                            <i class="fa-solid fa-search"></i>
                            <span>Tìm kiếm</span>
                        </button>

                        <a class="btn-light"
                           href="${pageContext.request.contextPath}/receptionist/members">
                            <i class="fa-solid fa-rotate-right"></i>
                            <span>Reset</span>
                        </a>
                    </div>
                </form>
            </div>

            <!-- TABLE -->
            <div class="page-card">

                <div class="table-responsive">
                    <table class="dashboard-table admin-table">

                        <thead>
                        <tr>
                            <th>Avatar</th>
                            <th>Hội viên</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Gói</th>
                            <th>Hết hạn</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>

                            <c:when test="${not empty memberPage.content}">
                                <c:forEach var="item" items="${memberPage.content}">
                                    <tr>

                                        <!-- AVATAR -->
                                        <td>
                                            <img class="table-avatar js-image-preview"
                                                 src="${pageContext.request.contextPath}/${empty item.avatar ? 'assets/images/default-avatar.png' : (item.avatar.startsWith('assets/') ? item.avatar : 'uploads/'.concat(item.avatar))}"
                                                 data-preview-label="${item.fullname}"
                                                 alt="${item.fullname}">
                                        </td>

                                        <!-- NAME -->
                                        <td>
                                            <strong>${empty item.fullname ? '---' : item.fullname}</strong>
                                        </td>

                                        <!-- PHONE -->
                                        <td>${empty item.phone ? '---' : item.phone}</td>

                                        <!-- EMAIL -->
                                        <td>${empty item.email ? '---' : item.email}</td>

                                        <!-- PACKAGE -->
                                        <td>${empty item.currentPackageName ? '---' : item.currentPackageName}</td>

                                        <!-- END DATE -->
                                        <td>${empty item.currentMembershipEndDate ? '---' : item.currentMembershipEndDate}</td>

                                        <!-- STATUS -->
                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hoạt động' : 'Ngừng'}
                                            </span>
                                        </td>

                                        <!-- ACTION -->
                                        <td>
                                            <div class="table-actions">

                                                <a class="btn-sm btn-light"
                                                   href="${pageContext.request.contextPath}/receptionist/members/detail/${item.memberId}"
                                                   title="Xem">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>

                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/receptionist/members/edit/${item.memberId}"
                                                   title="Sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                            </div>
                                        </td>

                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-cell">
                                        Không có hội viên
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>
                        </tbody>

                    </table>
                </div>

                <!-- PAGINATION -->
                <c:if test="${memberPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${memberPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == memberPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/receptionist/members?keyword=${keyword}&status=${status}&page=${p + 1}&size=${memberPage.size}">
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