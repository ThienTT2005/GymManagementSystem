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

String filePath = application.getRealPath("/") + "information.txt";

try {
    FileWriter fw = new FileWriter(filePath, true);
    fw.write("Name: " + fullname + "\n");
    fw.write("Phone: " + phone + "\n");
    fw.write("Height: " + height + "\n");
    fw.write("Weight: " + weight + "\n");
    fw.write("Age: " + age + "\n");
    fw.write("Gender: " + gender + "\n");
    fw.write("---------------------------\n");
    fw.close();

    out.print("success");

} catch(Exception e){
    out.print("error");
}
%>