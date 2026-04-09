<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-card">
                <h2>Chi tiết học viên</h2>

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
                    <a href="${pageContext.request.contextPath}/trainer/class-members?classId=${classIdOfStudent}"
                       class="btn-secondary">Quay lại</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>