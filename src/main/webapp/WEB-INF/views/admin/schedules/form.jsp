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

    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">

        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">

            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật lịch học' : 'Thêm lịch học'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <c:if test="${not empty org.springframework.validation.BindingResult.schedule}">
                <div class="alert-error">
                    <form:errors path="*" element="div"/>
                </div>
            </c:if>

            <div class="page-card form-card">

                <form:form method="post" modelAttribute="schedule" class="admin-form">

                    <c:if test="${isEdit}">
                        <form:hidden path="scheduleId"/>
                    </c:if>

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="classId">Lớp học</label>
                            <select id="classId" name="classId" required>
                                <option value="">-- Chọn lớp --</option>
                                <c:forEach var="c" items="${classes}">
                                    <option value="${c.classId}"
                                            <c:if test="${schedule.gymClass != null && schedule.gymClass.classId == c.classId}">selected</c:if>>
                                            ${c.className}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dayOfWeek">Thứ</label>
                            <form:select path="dayOfWeek" id="dayOfWeek">
                                <form:option value="MONDAY">MONDAY</form:option>
                                <form:option value="TUESDAY">TUESDAY</form:option>
                                <form:option value="WEDNESDAY">WEDNESDAY</form:option>
                                <form:option value="THURSDAY">THURSDAY</form:option>
                                <form:option value="FRIDAY">FRIDAY</form:option>
                                <form:option value="SATURDAY">SATURDAY</form:option>
                                <form:option value="SUNDAY">SUNDAY</form:option>
                            </form:select>
                            <form:errors path="dayOfWeek" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="startTime">Giờ bắt đầu</label>
                            <form:input path="startTime" id="startTime" type="time" step="1"/>
                            <form:errors path="startTime" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="endTime">Giờ kết thúc</label>
                            <form:input path="endTime" id="endTime" type="time" step="1"/>
                            <form:errors path="endTime" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="status">Trạng thái</label>
                            <form:select path="status" id="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng hoạt động</form:option>
                            </form:select>
                            <form:errors path="status" cssClass="error-text"/>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a href="${pageContext.request.contextPath}/admin/schedules"
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