
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.gym.model.User" %>

<%
    User user = (User) session.getAttribute("user");
%>

<html>
<head>
    <title>Member Home</title>
    <style>
        body {
            font-family: Arial;
            background: #fff;
            text-align: center;
        }

        .box {
            margin-top: 100px;
        }

        h1 {
            color: #e60023;
        }

        .btn {
            padding: 10px 20px;
            background: #e60023;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="box">
    <h1>Member Dashboard</h1>
    <p>Xin chào: <b><%= user.getFullName() %></b></p>

    <br>
    <a href="/logout" class="btn">Logout</a>
</div>

</body>
</html>