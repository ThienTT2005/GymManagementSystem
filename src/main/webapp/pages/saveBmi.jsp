<%@ page import="java.io.*" %>
<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String height = request.getParameter("height");
    String weight = request.getParameter("weight");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");
    String fullname = request.getParameter("fullname");
    String phone = request.getParameter("phone");
    
    if (fullname != null && phone != null) {
        String filePath = application.getRealPath("/") + "infomation.txt";
        try (PrintWriter outWriter = new PrintWriter(new BufferedWriter(new FileWriter(filePath, true)))) {
            outWriter.println("Tên (BMI): " + fullname);
            outWriter.println("Số điện thoại (BMI): " + phone);
            outWriter.println("Chiều cao: " + height + " cm");
            outWriter.println("Cân nặng: " + weight + " kg");
            outWriter.println("Tuổi: " + age);
            outWriter.println("Giới tính: " + gender);
            outWriter.println("---------------------------");
        } catch (IOException e) {
            e.printStackTrace();
        }
        out.print("success");
    } else {
        out.print("error");
    }
%>
