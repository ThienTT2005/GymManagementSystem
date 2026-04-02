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

        <form action="${pageContext.request.contextPath}/admin/contacts/save" method="post">
            <input type="hidden" name="contactId" value="${contact.contactId}"/>

            <div class="form-group">
                <label>Họ tên</label>
                <input type="text" name="fullName" value="${contact.fullName}" required>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone" value="${contact.phone}">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="${contact.email}">
            </div>

            <div class="form-group">
                <label>Nội dung</label>
                <textarea name="message">${contact.message}</textarea>
            </div>

            <div class="form-group">
                <label>Ngày liên hệ</label>
                <input type="date" name="contactDate" value="${contact.contactDate}">
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="Chưa xử lý" <c:if test="${contact.status == 'Chưa xử lý'}">selected</c:if>>Chưa xử lý</option>
                    <option value="Đã phản hồi" <c:if test="${contact.status == 'Đã phản hồi'}">selected</c:if>>Đã phản hồi</option>
                    <option value="Bỏ qua" <c:if test="${contact.status == 'Bỏ qua'}">selected</c:if>>Bỏ qua</option>
                </select>
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/contacts">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>