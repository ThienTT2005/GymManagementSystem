<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/schedules/save" method="post">
            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}"/>

            <div class="form-group">
                <label>Lớp học</label>
                <input type="text" name="className" value="${schedule.className}" required>
            </div>

            <div class="form-group">
                <label>Huấn luyện viên</label>
                <input type="text" name="trainerName" value="${schedule.trainerName}">
            </div>

            <div class="form-group">
                <label>Chi nhánh</label>
                <input type="text" name="branchName" value="${schedule.branchName}">
            </div>

            <div class="form-group">
                <label>Ngày</label>
                <input type="date" name="scheduleDate" value="${schedule.scheduleDate}">
            </div>

            <div class="form-group">
                <label>Giờ</label>
                <input type="text" name="scheduleTime" value="${schedule.scheduleTime}" placeholder="Ví dụ: 17:30">
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="Đang mở" <c:if test="${schedule.status == 'Đang mở'}">selected</c:if>>Đang mở</option>
                    <option value="Tạm dừng" <c:if test="${schedule.status == 'Tạm dừng'}">selected</c:if>>Tạm dừng</option>
                    <option value="Đã đóng" <c:if test="${schedule.status == 'Đã đóng'}">selected</c:if>>Đã đóng</option>
                </select>
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/schedules">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>