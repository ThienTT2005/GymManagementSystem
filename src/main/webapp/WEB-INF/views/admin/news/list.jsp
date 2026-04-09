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
                    <h1>Quản lý tin tức</h1>
                    <p>Danh sách bài viết / khuyến mãi</p>
                </div>
                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/news/create">
                    <i class="fa fa-plus"></i> Thêm bài viết
                </a>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card">
                <form method="get" action="${pageContext.request.contextPath}/admin/news" class="filter-form">
                    <div class="filter-group">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tiêu đề">
                    </div>

                    <div class="filter-group">
                        <select name="type">
                            <option value="">Tất cả loại</option>
                            <option value="NEWS" <c:if test="${type == 'NEWS'}">selected</c:if>>NEWS</option>
                            <option value="PROMOTION" <c:if test="${type == 'PROMOTION'}">selected</c:if>>PROMOTION</option>
                            <option value="BLOG" <c:if test="${type == 'BLOG'}">selected</c:if>>BLOG</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" <c:if test="${status == 1}">selected</c:if>>Hiển thị</option>
                            <option value="0" <c:if test="${status == 0}">selected</c:if>>Ẩn</option>
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
                            <th>Ảnh</th>
                            <th>Tiêu đề</th>
                            <th>Loại</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty newsPage.content}">
                                <c:forEach var="item" items="${newsPage.content}">
                                    <tr>
                                        <td>${item.postId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.image}">
                                                    <img class="thumb-image"
                                                         src="${pageContext.request.contextPath}/assets/images/${item.image}"
                                                         alt="${item.title}">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="no-image">No image</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${item.title}</td>
                                        <td>${item.type}</td>
                                        <td>
                                            <span class="${item.status == 1 ? 'badge-active' : 'badge-inactive'}">
                                                <c:choose>
                                                    <c:when test="${item.status == 1}">Hiển thị</c:when>
                                                    <c:otherwise>Ẩn</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <a class="btn-sm btn-edit"
                                               href="${pageContext.request.contextPath}/admin/news/edit/${item.postId}">
                                                Sửa
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/news/delete/${item.postId}"
                                                  style="display:inline-block"
                                                  onsubmit="return confirm('Bạn có chắc muốn ẩn bài viết này?');">
                                                <button type="submit" class="btn-sm btn-delete">Ẩn</button>
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

                <c:if test="${newsPage.totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="0" end="${newsPage.totalPages - 1}" var="p">
                            <a class="${p + 1 == newsPage.number + 1 ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/news?keyword=${keyword}&type=${type}&status=${status}&page=${p + 1}&size=${newsPage.size}">
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