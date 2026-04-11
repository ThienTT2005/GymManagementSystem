package com.gym.GymManagementSystem.newsblog;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NewsBlogDAO {

    private volatile String resolvedTable;
    private volatile Mode resolvedMode;

    private enum Mode {
        NEWS_ENTITY_TABLE,
        NEWS_BLOGS_TABLE
    }

    public void save(NewsBlog news) throws SQLException {
        Resolve r = resolve();
        String sql;
        if (r.mode == Mode.NEWS_ENTITY_TABLE) {
            sql = """
                    INSERT INTO %s (title, content, category, image, created_date)
                    VALUES (?, ?, ?, ?, ?)
                    """.formatted(r.table);
        } else {
            sql = """
                    INSERT INTO %s (title, content, category, image_url, created_at)
                    VALUES (?, ?, ?, ?, ?)
                    """.formatted(r.table);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getContent());
            ps.setString(3, news.getCategory());
            ps.setString(4, news.getImageUrl());

            LocalDateTime createdAt = news.getCreatedAt() != null ? news.getCreatedAt() : LocalDateTime.now();
            if (r.mode == Mode.NEWS_ENTITY_TABLE) {
                ps.setDate(5, Date.valueOf(createdAt.toLocalDate()));
            } else {
                ps.setTimestamp(5, Timestamp.valueOf(createdAt));
            }
            ps.executeUpdate();
        }
    }

    public List<NewsBlog> findByCategory(String category, int page, int size) throws SQLException {
        List<NewsBlog> result = new ArrayList<>();

        Resolve r = resolve();
        StringBuilder sql = new StringBuilder();
        if (r.mode == Mode.NEWS_ENTITY_TABLE) {
            sql.append("SELECT news_id, title, content, category, image, created_date FROM ").append(r.table);
        } else {
            sql.append("SELECT id, title, content, category, image_url, created_at FROM ").append(r.table);
        }
        List<Object> params = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            sql.append(" WHERE category = ?");
            params.add(category);
        }

        if (r.mode == Mode.NEWS_ENTITY_TABLE) {
            sql.append(" ORDER BY created_date DESC LIMIT ? OFFSET ?");
        } else {
            sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        }
        int offset = (page - 1) * size;

        params.add(size);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
            }
        }

        return result;
    }

    public long countByCategory(String category) throws SQLException {
        Resolve r = resolve();
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ").append(r.table);
        List<Object> params = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            sql.append(" WHERE category = ?");
            params.add(category);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }

        return 0L;
    }

    private NewsBlog mapRow(ResultSet rs) throws SQLException {
        NewsBlog news = new NewsBlog();
        Resolve r = resolve();
        if (r.mode == Mode.NEWS_ENTITY_TABLE) {
            news.setId(rs.getLong("news_id"));
            news.setTitle(rs.getString("title"));
            news.setContent(rs.getString("content"));
            news.setCategory(rs.getString("category"));
            news.setImageUrl(rs.getString("image"));

            Date d = rs.getDate("created_date");
            if (d != null) {
                news.setCreatedAt(d.toLocalDate().atStartOfDay());
            }
        } else {
            news.setId(rs.getLong("id"));
            news.setTitle(rs.getString("title"));
            news.setContent(rs.getString("content"));
            news.setCategory(rs.getString("category"));
            news.setImageUrl(rs.getString("image_url"));

            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                news.setCreatedAt(ts.toLocalDateTime());
            }
        }

        return news;
    }

    private static class Resolve {
        final String table;
        final Mode mode;

        Resolve(String table, Mode mode) {
            this.table = table;
            this.mode = mode;
        }
    }

    private Resolve resolve() throws SQLException {
        String t = resolvedTable;
        Mode m = resolvedMode;
        if (t != null && m != null) {
            return new Resolve(t, m);
        }

        // Ưu tiên bảng user đang nói: `news_blogs` / `news-blog` / `news_blog` / `News_Blogs` trước, rồi fallback `news`
        String[] candidates = new String[] { "news_blogs", "news-blog", "news_blog", "News_Blogs", "news" };

        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            for (String raw : candidates) {
                String quoted = quoteTable(raw);
                if (tableExists(conn, raw)) {
                    Mode mode = raw.equals("news") ? Mode.NEWS_ENTITY_TABLE : Mode.NEWS_BLOGS_TABLE;
                    resolvedTable = quoted;
                    resolvedMode = mode;
                    return new Resolve(quoted, mode);
                }
            }
        }

        // Nếu không detect được (lạ), cứ dùng `news` để khỏi crash.
        resolvedTable = quoteTable("news");
        resolvedMode = Mode.NEWS_ENTITY_TABLE;
        return new Resolve(resolvedTable, resolvedMode);
    }

    private boolean tableExists(Connection conn, String tableName) throws SQLException {
        String sql = """
                SELECT 1
                FROM information_schema.tables
                WHERE table_schema = DATABASE()
                  AND table_name = ?
                LIMIT 1
                """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private String quoteTable(String tableName) {
        // backticks để support tên bảng có dấu '-' như `news-blog`
        String safe = tableName.replace("`", "``");
        return "`" + safe + "`";
    }
}

