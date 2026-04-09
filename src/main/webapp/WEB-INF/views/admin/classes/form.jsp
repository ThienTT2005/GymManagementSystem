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
                    <h1>${isEdit ? 'Cập nhật lớp học' : 'Thêm lớp học'}</h1>
                    <p>Lớp học gồm tên, service, trainer, max/current member, mô tả</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="gymClass" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Tên lớp</label>
                            <form:input path="className"/>
                        </div>

                        <div class="form-group">
                            <label>Dịch vụ</label>
                            <select name="serviceId">
                                <option value="">-- Chọn dịch vụ --</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.serviceId}"
                                        <c:if test="${gymClass.service != null && gymClass.service.serviceId == s.serviceId}">selected</c:if>>
                                            ${s.serviceName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Trainer</label>
                            <select name="trainerId">
                                <option value="">-- Chọn trainer --</option>
                                <c:forEach var="t" items="${trainers}">
                                    <option value="${t.trainerId}"
                                        <c:if test="${gymClass.trainer != null && gymClass.trainer.trainerId == t.trainerId}">selected</c:if>>
                                            ${t.staffName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Số lượng tối đa</label>
                            <form:input path="maxMember" type="number"/>
                        </div>

                        <div class="form-group">
                            <label>Số lượng hiện tại</label>
                            <form:input path="currentMember" type="number"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Mô tả</label>
                            <form:textarea path="description" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/classes" class="btn-secondary">Quay lại</a>
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