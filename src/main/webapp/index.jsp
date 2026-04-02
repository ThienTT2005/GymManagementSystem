<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to the actual index page inside pages directory
    response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
%>
