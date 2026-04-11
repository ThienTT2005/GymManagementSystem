package com.gym.GymManagementSystem.newsblog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "NewsApiServlet", urlPatterns = "/api/news")
public class NewsApiServlet extends HttpServlet {

    private final NewsBlogDAO newsBlogDAO = new NewsBlogDAO();
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String category = request.getParameter("category");

        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int size = parseIntOrDefault(request.getParameter("size"), 9);
        if (page < 1) page = 1;
        if (size < 1) size = 9;

        try (PrintWriter out = response.getWriter()) {
            List<NewsBlog> content = newsBlogDAO.findByCategory(category, page, size);
            long total = newsBlogDAO.countByCategory(category);

            long totalPages = total == 0 ? 1 : (long) Math.ceil((double) total / size);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"page\":").append(page).append(",");
            json.append("\"totalPages\":").append(totalPages).append(",");
            json.append("\"content\":[");

            for (int i = 0; i < content.size(); i++) {
                NewsBlog n = content.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{");
                json.append("\"id\":").append(n.getId() == null ? "null" : n.getId()).append(",");
                json.append("\"title\":").append(toJsonString(n.getTitle())).append(",");
                json.append("\"content\":").append(toJsonString(n.getContent())).append(",");
                json.append("\"category\":").append(toJsonString(n.getCategory())).append(",");
                json.append("\"imageUrl\":").append(toJsonString(n.getImageUrl())).append(",");
                String createdAt = n.getCreatedAt() != null ? formatter.format(n.getCreatedAt()) : null;
                json.append("\"createdAt\":").append(toJsonString(createdAt));
                json.append("}");
            }

            json.append("]}");
            out.write(json.toString());
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String toJsonString(String value) {
        if (value == null) {
            return "null";
        }
        String escaped = value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }
}

