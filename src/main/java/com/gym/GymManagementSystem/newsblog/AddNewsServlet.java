package com.gym.GymManagementSystem.newsblog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet(name = "AddNewsServlet", urlPatterns = "/admin/addNews")
public class AddNewsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        NewsBlog news = new NewsBlog();
        news.setTitle(title);
        news.setContent(content);
        news.setCategory(category);
        news.setImageUrl(imageUrl);
        news.setCreatedAt(LocalDateTime.now());

        NewsBlogDAO dao = new NewsBlogDAO();
        try {
            dao.save(news);
            response.sendRedirect(request.getContextPath() + "/pages/News.jsp");
        } catch (SQLException e) {
            throw new ServletException("Không thể lưu tin tức", e);
        }
    }
}

