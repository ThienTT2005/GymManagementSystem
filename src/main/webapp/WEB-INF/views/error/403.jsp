<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>403 - Cấm truy cập</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: #f7f7f7;
            color: #222;
        }

        .error-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .error-box {
            width: 100%;
            max-width: 460px;
            background: #fff;
            border: 1px solid #eadede;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
            padding: 32px 28px;
            text-align: center;
        }

        .error-code {
            font-size: 64px;
            font-weight: 700;
            color: #b30000;
            line-height: 1;
            margin-bottom: 12px;
        }

        .error-title {
            font-size: 24px;
            font-weight: 700;
            color: #222;
            margin-bottom: 10px;
        }

        .error-text {
            font-size: 15px;
            color: #666;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .error-actions {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 16px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 700;
            transition: 0.2s ease;
        }

        .btn-primary {
            background: #b30000;
            color: #fff;
        }

        .btn-primary:hover {
            background: #930000;
        }

        .btn-light {
            background: #fff;
            color: #b30000;
            border: 1px solid #e4cfcf;
        }

        .btn-light:hover {
            background: #fff6f6;
        }
    </style>
</head>
<body>
<div class="error-wrapper">
    <div class="error-box">
        <div class="error-code">403</div>
        <div class="error-title">Bạn không có quyền truy cập</div>
        <div class="error-text">
            Tài khoản hiện tại không được phép vào trang này.
        </div>

        <div class="error-actions">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/login">Về đăng nhập</a>
            <a class="btn btn-light" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>
</div>
</body>
</html>