<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

        <form action="${pageContext.request.contextPath}/admin/trials/save" method="post">
            <input type="hidden" name="trialId" value="${trial.trialId}"/>

            <div class="form-group">
                <label>Họ tên</label>
                <input type="text" name="fullName" value="${trial.fullName}" required>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone" value="${trial.phone}" required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="${trial.email}">
            </div>

            <div class="form-group">
                <label>Chi nhánh</label>
                <input type="text" name="branchName" value="${trial.branchName}">
            </div>

            <div class="form-group">
                <label>Ngày đăng ký</label>
                <input type="date" name="registerDate" value="${trial.registerDate}">
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="Chờ liên hệ" ${trial.status == 'Chờ liên hệ' ? 'selected' : ''}>Chờ liên hệ</option>
                    <option value="Đã liên hệ" ${trial.status == 'Đã liên hệ' ? 'selected' : ''}>Đã liên hệ</option>
                    <option value="Từ chối" ${trial.status == 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                </select>
            </div>

            <button type="submit" class="btn-save">Lưu</button>
            <a class="btn-back" href="${pageContext.request.contextPath}/admin/trials">Quay lại</a>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>