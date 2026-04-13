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
                    <h1>Quản lý tin tức</h1>
                </div>

                <a class="btn-primary" href="${pageContext.request.contextPath}/admin/news/create">
                    <i class="fa-solid fa-plus"></i>
                    <span>Thêm bài viết</span>
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
                      action="${pageContext.request.contextPath}/admin/news"
                      class="filter-form">

                    <div class="filter-group search-group">
                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Tìm theo tiêu đề">
                    </div>

                    <div class="filter-group">
                        <select name="type">
                            <option value="">Loại</option>
                            <option value="NEWS" ${type=='NEWS'?'selected':''}>Tin tức</option>
                            <option value="PROMOTION" ${type=='PROMOTION'?'selected':''}>Khuyến mãi</option>
                            <option value="BLOG" ${type=='BLOG'?'selected':''}>Blog</option>
                            <option value="STORY" ${type=='STORY'?'selected':''}>Câu chuyện hội viên</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="status">
                            <option value="">Trạng thái</option>
                            <option value="1" ${status==1?'selected':''}>Hiển thị</option>
                            <option value="0" ${status==0?'selected':''}>Ẩn</option>
                        </select>
                    </div>

                    <button class="btn-secondary" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm</span>
                    </button>

                    <a class="btn-light"
                       href="${pageContext.request.contextPath}/admin/news">
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
                            <th>Ảnh</th>
                            <th>Tiêu đề</th>
                            <th>Loại</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:choose>

                            <c:when test="${not empty newsPage.content}">
                                <c:forEach var="item" items="${newsPage.content}" varStatus="loop">

                                    <tr>

                                        <td>
                                            ${newsPage.number * newsPage.size + loop.index + 1}
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.image}">
                                                    <img class="thumb-image"
                                                         src="${pageContext.request.contextPath}/uploads/${item.image}"
                                                         alt="${item.title}">
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td><strong>${item.title}</strong></td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${item.type=='NEWS'}">Tin tức</c:when>
                                                <c:when test="${item.type=='PROMOTION'}">Khuyến mãi</c:when>
                                                <c:when test="${item.type=='BLOG'}">Blog</c:when>
                                                <c:when test="${item.type=='STORY'}">Câu chuyện hội viên</c:when>
                                                <c:otherwise>${item.type}</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <span class="status-badge ${item.status == 1 ? 'active' : 'inactive'}">
                                                ${item.status == 1 ? 'Hiển thị' : 'Ẩn'}
                                            </span>
                                        </td>

                                        <td>
                                            <div class="table-actions">

                                                <a class="btn-sm btn-edit"
                                                   href="${pageContext.request.contextPath}/admin/news/edit/${item.postId}"
                                                   title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/news/toggle-status/${item.postId}"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Xác nhận thay đổi trạng thái bài viết?');">

                                                    <button class="btn-sm ${item.status == 1 ? 'btn-toggle-off' : 'btn-toggle-on'}"
                                                            type="submit"
                                                            title="${item.status == 1 ? 'Ẩn bài viết' : 'Hiển thị bài viết'}">
                                                        <i class="fa-solid ${item.status == 1 ? 'fa-toggle-on' : 'fa-toggle-off'}"></i>
                                                    </button>

                                                </form>

                                            </div>
                                        </td>

                                    </tr>

                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-cell">
                                        Không có dữ liệu
                                    </td>
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