<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CodeGym - Dịch Vụ</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Roboto', sans-serif; display: flex; flex-direction: column; min-height: 100vh; background: #fafafa; }
        .page-content { flex: 1; padding: 80px 20px; text-align: center; }
        .page-content h1 { color: #8d1317; font-size: 36px; margin-bottom: 20px; }
        .page-content p { color: #555; font-size: 18px; }
    </style>
</head>
<body>
    <jsp:include page="../components/header.jsp" />
    <div class="page-content">
        <h1>DỊCH VỤ</h1>
        <p>Nội dung trang Dịch Vụ đang được cập nhật...</p>
    </div>
    <jsp:include page="../components/footer.jsp" />
</body>
</html>
