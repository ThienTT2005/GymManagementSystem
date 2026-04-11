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

    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">

        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">

            <div class="page-header">
                <div>
                    <h1>Quản lý đăng ký gói tập</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">

                <form method="get"
                      action="${pageContext.request.contextPath}/admin/memberships"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tên hội viên">
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" ${status=='PENDING'?'selected':''}>Chờ xử lý</option>
                            <option value="ACTIVE" ${status=='ACTIVE'?'selected':''}>Đang hoạt động</option>
                            <option value="REJECTED" ${status=='REJECTED'?'selected':''}>Từ chối</option>
                            <option value="EXPIRED" ${status=='EXPIRED'?'selected':''}>Hết hạn</option>
                            <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>Đã hủy</option>
                        </select>
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm<span>
                    </button>

                    <a class="btn-light"
                       href="${pageContext.request.contextPath}/admin/memberships">
                        <i class="fa-solid fa-rotate-right"></i>
                        <span>Reset</span>
                    </a>

                </form>

            </div>

            <div class="page-card">

                <div class="table-responsive">

                    <table class="dashboard-table admin-table">

                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hội viên</th>
                            <th>Gói tập</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty membershipPage.content}">
                                <c:forEach var="item" items="${membershipPage.content}" varStatus="loop">

                                    <tr>

                                        <td>
                                            ${membershipPage.number * membershipPage.size + loop.index + 1}
                                        </td>

                                        <td>
                                            <strong>
                                                ${item.member != null ? item.member.fullname : '-'}
                                            </strong>
                                        </td>

                                        <td>
                                            ${item.gymPackage != null ? item.gymPackage.packageName : '-'}
                                        </td>

                                        <td>${item.startDate}</td>
                                        <td>${item.endDate}</td>
                                        <td>${empty item.paymentStatusDisplay ? 'CHƯA THANH TOÁN' : item.paymentStatusDisplay}</td>

                                        <td>
                                            <span class="status-badge
                                                ${item.status == 'ACTIVE' ? 'active' :
                                                  item.status == 'PENDING' ? 'pending' :
                                                  item.status == 'EXPIRED' ? 'inactive' :
                                                  item.status == 'REJECTED' ? 'inactive' : 'inactive'}">

                                                <c:choose>
                                                    <c:when test="${item.status == 'ACTIVE'}">Hoạt động</c:when>
                                                    <c:when test="${item.status == 'PENDING'}">Chờ xử lý</c:when>
                                                    <c:when test="${item.status == 'REJECTED'}">Từ chối</c:when>
                                                    <c:when test="${item.status == 'EXPIRED'}">Hết hạn</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>

                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">
                                                <c:if test="${item.status == 'PENDING'}">
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/admin/memberships/approve/${item.membershipId}"
                                                          class="inline-form"
                                                          onsubmit="return confirm('Chỉ duyệt khi thanh toán đã ở trạng thái PAID. Tiếp tục?');">
                                                        <button class="btn-sm btn-approve" type="submit" title="Duyệt">
                                                            <i class="fa-solid fa-check"></i>
                                                        </button>
                                                    </form>

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/admin/memberships/reject/${item.membershipId}"
                                                          class="inline-form"
                                                          onsubmit="return confirm('Xác nhận từ chối đăng ký này?');">
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
                                    <td colspan="8" class="empty-cell">
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

                <c:if test="${membershipPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${membershipPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == membershipPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/memberships?keyword=${keyword}&status=${status}&page=${p + 1}&size=${membershipPage.size}">
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