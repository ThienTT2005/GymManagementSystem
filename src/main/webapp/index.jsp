<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to the Spring MVC home controller so database news can load
    response.sendRedirect(request.getContextPath() + "/index");
%>
