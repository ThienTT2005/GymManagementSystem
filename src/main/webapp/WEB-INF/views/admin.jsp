<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <div style="border: 2px solid red; padding: 20px;">
        <h1 style="color: red;">ĐÂY LÀ TRANG QUẢN TRỊ (ADMIN)</h1>
        
        <%-- Hiển thị tên từ đối tượng 'account' đã lưu vào session --%>
        <h2>Xin chào Admin: ${sessionScope.account.username}</h2>
        <p>Họ tên: ${sessionScope.account.fullName}</p>
        <p>Email: ${sessionScope.account.email}</p>
        
        <hr>
        <a href="logout" style="color: blue; font-weight: bold;">[ ĐĂNG XUẤT ]</a>
    </div>
</body>
</html>