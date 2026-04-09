<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-card form-card">
                <h2>Thêm đăng ký lớp</h2>

                <form:form method="post" modelAttribute="registration" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Hội viên</label>
                            <select name="memberId">
                                <option value="">-- Chọn hội viên --</option>
                                <c:forEach var="m" items="${members}">
                                    <option value="${m.memberId}">${m.fullname} - ${m.phone}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Lớp học</label>
                            <select name="classId">
                                <option value="">-- Chọn lớp --</option>
                                <c:forEach var="c" items="${classes}">
                                    <option value="${c.classId}">${c.className}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Dịch vụ</label>
                            <select name="serviceId">
                                <option value="">-- Chọn dịch vụ --</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.serviceId}">${s.serviceName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Ngày bắt đầu</label>
                            <form:input path="startDate" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày kết thúc</label>
                            <form:input path="endDate" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày đăng ký</label>
                            <form:input path="registrationDate" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="PENDING">PENDING</form:option>
                                <form:option value="ACTIVE">ACTIVE</form:option>
                                <form:option value="REJECTED">REJECTED</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/class-registrations" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">Thêm mới</button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>