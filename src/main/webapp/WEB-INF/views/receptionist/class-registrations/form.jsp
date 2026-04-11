<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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

            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật đăng ký lớp' : 'Thêm đăng ký lớp'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="registration" class="admin-form">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label>Hội viên</label>
                            <select name="memberId" required>
                                <option value="">-- Chọn hội viên --</option>
                                <c:forEach var="m" items="${members}">
                                    <option value="${m.memberId}"
                                        <c:if test="${registration.member != null && registration.member.memberId == m.memberId}">selected</c:if>>
                                            ${m.fullname} - ${m.phone}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label>Lớp học</label>
                            <select name="classId" required>
                                <option value="">-- Chọn lớp --</option>
                                <c:forEach var="c" items="${classes}">
                                    <option value="${c.classId}"
                                        <c:if test="${registration.gymClass != null && registration.gymClass.classId == c.classId}">selected</c:if>>
                                            ${c.className}
                                            <c:if test="${c.service != null}"> - ${c.service.serviceName}</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                            <p class="field-hint">Dịch vụ sẽ tự lấy theo lớp học đã chọn.</p>
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
                                <form:option value="PENDING">Chờ xử lý</form:option>
                                <form:option value="CANCELLED">Đã hủy</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>

                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/class-registrations"
                           class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>${isEdit ? 'Cập nhật' : 'Thêm mới'}</span>
                        </button>
                    </div>

                </form:form>
            </div>

        </main>
    </div>
</div>
</body>
</html>