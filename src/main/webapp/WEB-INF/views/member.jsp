<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Member Dashboard</title>
</head>
<body>
    <div style="border: 2px solid green; padding: 20px;">
        <h1 style="color: green;">ĐÂY LÀ TRANG HỘI VIÊN (MEMBER)</h1>
        
        <h2>Chào mừng bạn, ${sessionScope.account.fullName}!</h2>
        <p>Tài khoản: ${sessionScope.account.username}</p>
        
        <hr>
        <p>Nơi đây hiển thị các chức năng dành cho Member của phòng Gym.</p>
        
        <br>
        <a href="logout" style="color: blue; font-weight: bold;">[ ĐĂNG XUẤT ]</a>
    </div>
</body>
</html>