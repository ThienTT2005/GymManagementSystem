<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="page-box news-page-box">
        <div class="page-header">
            <div class="page-title">Quản lý tin tức</div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/admin/news" class="toolbar toolbar-members-one-row">
            <div class="toolbar-members-group">
                <div class="search-box members-search-box">
                    <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text"
                           name="keyword"
                           placeholder="Tìm theo tiêu đề hoặc nội dung..."
                           value="${param.keyword}">
                </div>
            </div>

            <div class="toolbar-members-actions">
                <button type="submit" class="btn-filter">
                    <i class="fa-solid fa-filter"></i> Lọc
                </button>

                <a class="btn-add" href="${pageContext.request.contextPath}/admin/news/create">
                    <i class="fa-solid fa-plus"></i> Thêm tin tức
                </a>
            </div>
        </form>

        <div class="table-box">
            <table class="admin-table news-table">
                <thead>
                <tr>
                    <th>Tiêu đề</th>
                    <th>Nội dung</th>
                    <th>Ảnh</th>
                    <th>Ngày đăng</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${newsList}">
                    <tr>
                        <td class="text-strong news-title-cell">${item.title}</td>

                        <td class="news-content-cell">
                            <c:choose>
                                <c:when test="${fn:length(item.content) > 120}">
                                    ${fn:substring(item.content, 0, 120)}...
                                </c:when>
                                <c:otherwise>
                                    ${item.content}
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty item.image}">
                                    <img src="${pageContext.request.contextPath}${item.image}"
                                         alt="news"
                                         class="thumb-mini">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Chưa có ảnh</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="small-date">${item.createdAt}</td>

                        <td>
                            <div class="table-actions">
                                <a class="btn-edit"
                                   href="${pageContext.request.contextPath}/admin/news/edit/${item.postId}">
                                    <i class="fa-regular fa-pen-to-square"></i> Sửa
                                </a>

                                <a class="btn-delete"
                                   href="${pageContext.request.contextPath}/admin/news/delete/${item.postId}"
                                   onclick="return confirm('Bạn có chắc muốn xóa tin tức này?')">
                                    <i class="fa-regular fa-trash-can"></i> Xóa
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty newsList}">
                    <tr>
                        <td colspan="5" class="empty-text">Chưa có dữ liệu tin tức</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-box">
                <c:choose>
                    <c:when test="${currentPage > 0}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/news?page=${currentPage - 1}&size=${size}&keyword=${param.keyword}">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-left"></i></span>
                    </c:otherwise>
                </c:choose>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="page-item ${i == currentPage ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/news?page=${i}&size=${size}&keyword=${param.keyword}">
                        ${i + 1}
                    </a>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages - 1}">
                        <a class="page-item"
                           href="${pageContext.request.contextPath}/admin/news?page=${currentPage + 1}&size=${size}&keyword=${param.keyword}">
                            <i class="fa-solid fa-angle-right"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="page-item disabled"><i class="fa-solid fa-angle-right"></i></span>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>