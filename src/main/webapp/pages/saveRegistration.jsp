<%@ page import="java.io.*, java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    if (email == null) email = "";

    boolean isSuccess = true;

    // 1. Ghi vào database (giả định dùng MySQL mặc định hoặc tương tự)
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management?useUnicode=true&characterEncoding=UTF-8", "root", "");
        String sql = "INSERT INTO registration (name, phone, email) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, phone);
        pstmt.setString(3, email);
        pstmt.executeUpdate();
    } catch (Exception e) {
        // Có thể DB chưa cài đặt/cấu hình, bỏ qua ngoại lệ để vẫn lưu file text tránh phá cứng luồng
        System.out.println("DB Connection error: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    // 2. Lưu lại vào infomation.txt như yêu cầu
    String filePath = application.getRealPath("/") + "infomation.txt";
    try {
        FileWriter fw = new FileWriter(filePath, true);
        fw.write("Tên: " + name + "\n");
        fw.write("Số điện thoại: " + phone + "\n");
        fw.write("Email: " + email + "\n");
        fw.write("---------------------------\n");
        fw.close();
    } catch (Exception e) {
        isSuccess = false;
        System.out.println("File write error: " + e.getMessage());
    }

    if (isSuccess) {
        out.print("success");
    } else {
        out.print("error");
    }
%>
