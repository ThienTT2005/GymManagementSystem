<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
                    <h1>${isEdit ? 'Cập nhật đăng ký gói tập' : 'Thêm đăng ký gói tập'}</h1>
                    <p>Nhập thông tin đăng ký gói tập</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="membership" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Hội viên</label>
                            <select name="memberId">
                                <option value="">-- Chọn hội viên --</option>
                                <c:forEach var="m" items="${members}">
                                    <option value="${m.memberId}"
                                        <c:if test="${membership.member != null && membership.member.memberId == m.memberId}">selected</c:if>>
                                            ${m.fullname}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Gói tập</label>
                            <select name="packageId">
                                <option value="">-- Chọn gói tập --</option>
                                <c:forEach var="p" items="${packages}">
                                    <option value="${p.packageId}"
                                        <c:if test="${membership.gymPackage != null && membership.gymPackage.packageId == p.packageId}">selected</c:if>>
                                            ${p.packageName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Ngày bắt đầu</label>
                            <form:input path="startDate" type="date"/>
                            <form:errors path="startDate" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày kết thúc</label>
                            <form:input path="endDate" type="date"/>
                            <form:errors path="endDate" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="PENDING">PENDING</form:option>
                                <form:option value="ACTIVE">ACTIVE</form:option>
                                <form:option value="EXPIRED">EXPIRED</form:option>
                                <form:option value="CANCELLED">CANCELLED</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/memberships" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">
                            <c:choose>
                                <c:when test="${isEdit}">Cập nhật</c:when>
                                <c:otherwise>Thêm mới</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>