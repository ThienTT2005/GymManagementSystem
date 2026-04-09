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
                    <h1>${isEdit ? 'Cập nhật lịch học' : 'Thêm lịch học'}</h1>
                    <p>Không dùng room, chỉ dùng class + day + time</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="schedule" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Lớp học</label>
                            <select name="classId">
                                <option value="">-- Chọn lớp học --</option>
                                <c:forEach var="c" items="${classes}">
                                    <option value="${c.classId}"
                                        <c:if test="${schedule.gymClass != null && schedule.gymClass.classId == c.classId}">selected</c:if>>
                                            ${c.className}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Thứ</label>
                            <form:select path="dayOfWeek">
                                <form:option value="MONDAY">MONDAY</form:option>
                                <form:option value="TUESDAY">TUESDAY</form:option>
                                <form:option value="WEDNESDAY">WEDNESDAY</form:option>
                                <form:option value="THURSDAY">THURSDAY</form:option>
                                <form:option value="FRIDAY">FRIDAY</form:option>
                                <form:option value="SATURDAY">SATURDAY</form:option>
                                <form:option value="SUNDAY">SUNDAY</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label>Giờ bắt đầu</label>
                            <form:input path="startTime" type="time"/>
                        </div>

                        <div class="form-group">
                            <label>Giờ kết thúc</label>
                            <form:input path="endTime" type="time"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/schedules" class="btn-secondary">Quay lại</a>
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