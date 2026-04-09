<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
            <div class="page-card">
                <h2>Chi tiết hội viên</h2>

                <div class="detail-grid">
                    <div><strong>Họ tên:</strong> ${member.fullname}</div>
                    <div><strong>Số điện thoại:</strong> ${member.phone}</div>
                    <div><strong>Email:</strong> ${member.email}</div>
                    <div><strong>Địa chỉ:</strong> ${member.address}</div>
                    <div><strong>Giới tính:</strong> ${member.gender}</div>
                    <div><strong>Ngày sinh:</strong> ${member.dob}</div>
                    <div><strong>Trạng thái:</strong> ${member.status == 1 ? 'Hoạt động' : 'Ngừng'}</div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/receptionist/members" class="btn-secondary">Quay lại</a>
                    <a href="${pageContext.request.contextPath}/receptionist/members/edit/${member.memberId}" class="btn-primary">Sửa</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>