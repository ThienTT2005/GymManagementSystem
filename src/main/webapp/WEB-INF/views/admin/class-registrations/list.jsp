<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Quản lý đăng ký lớp</h1>
                    <p>Danh sách hội viên đăng ký lớp học</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/class-registrations/create">
                    <i class="fa fa-plus"></i> Thêm đăng ký
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/class-registrations" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm tên hội viên">
                    </div>

                    <div class="filter-group">
                        <select name="classId">
                            <option value="">Tất cả lớp</option>
                            <c:forEach var="c" items="${classes}">
                                <option value="${c.classId}" <c:if test="${classId == c.classId}">selected</c:if>>
                                    ${c.className}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" <c:if test="${status == 'PENDING'}">selected</c:if>>PENDING</option>
                            <option value="ACTIVE" <c:if test="${status == 'ACTIVE'}">selected</c:if>>ACTIVE</option>
                            <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>REJECTED</option>
                            <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-secondary">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                </form>

                <div class="table-wrap">
                    <table class="dashboard-table admin-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hội viên</th>
                            <th>Lớp</th>
                            <th>Dịch vụ</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty registrationPage.content}">
                                <c:forEach var="item" items="${registrationPage.content}">
                                    <tr>
                                        <td>${item.registrationId}</td>
                                        <td>${item.member.fullname}</td>
                                        <td>${item.gymClass.className}</td>
                                        <td>${item.service != null ? item.service.serviceName : ''}</td>
                                        <td>${item.startDate}</td>
                                        <td>${item.endDate}</td>
                                        <td>
                                            <span class="
                                                ${item.status == 'ACTIVE' ? 'badge-active' : ''}
                                                ${item.status == 'PENDING' ? 'badge-warning' : ''}
                                                ${item.status == 'REJECTED' || item.status == 'CANCELLED' ? 'badge-inactive' : ''}">
                                                ${item.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/admin/class-registrations/edit/${item.registrationId}">
                                                Sửa
                                            </a>

                                            <c:if test="${item.status == 'PENDING'}">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/class-registrations/approve/${item.registrationId}"
                                                      style="display:inline-block">
                                                    <button type="submit" class="btn-sm btn-approve">Duyệt</button>
                                                </form>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/class-registrations/reject/${item.registrationId}"
                                                      style="display:inline-block">
                                                    <button type="submit" class="btn-sm btn-delete">Từ chối</button>
                                                </form>
                                            </c:if>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/class-registrations/delete/${item.registrationId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn hủy đăng ký lớp này?');">
                                                <button type="submit" class="btn-sm btn-delete">Hủy</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-cell">Không có dữ liệu</td>
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
                               href="${pageContext.request.contextPath}/admin/class-registrations?keyword=${keyword}&status=${status}&classId=${classId}&page=${p + 1}&size=${registrationPage.size}">
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