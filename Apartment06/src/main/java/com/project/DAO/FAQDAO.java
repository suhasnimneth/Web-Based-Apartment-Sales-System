// src/main/java/com/project/DAO/FAQDAO.java
package com.project.DAO;

import com.project.model.FAQ;
import com.project.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FAQDAO {

    public List<FAQ> getAllActiveFAQs() throws SQLException {
        String sql = "SELECT * FROM faqs WHERE is_active = 1 ORDER BY display_order, faq_id";
        List<FAQ> faqs = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                FAQ faq = mapResultSetToFAQ(rs);
                faqs.add(faq);
            }
        }
        return faqs;
    }

    public List<FAQ> getFAQsByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM faqs WHERE is_active = 1 AND category = ? ORDER BY display_order, faq_id";
        List<FAQ> faqs = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FAQ faq = mapResultSetToFAQ(rs);
                    faqs.add(faq);
                }
            }
        }
        return faqs;
    }

    public List<String> getCategories() throws SQLException {
        String sql = "SELECT DISTINCT category FROM faqs WHERE is_active = 1 ORDER BY category";
        List<String> categories = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        }
        return categories;
    }

    // For admin: get all FAQs including inactive
    public List<FAQ> getAllFAQs() throws SQLException {
        String sql = "SELECT * FROM faqs ORDER BY category, display_order, faq_id";
        List<FAQ> faqs = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                FAQ faq = mapResultSetToFAQ(rs);
                faqs.add(faq);
            }
        }
        return faqs;
    }

    // For admin: add new FAQ
    public void addFAQ(FAQ faq) throws SQLException {
        String sql = "INSERT INTO faqs (question, answer, category, display_order, is_active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, faq.getQuestion());
            stmt.setString(2, faq.getAnswer());
            stmt.setString(3, faq.getCategory());
            stmt.setInt(4, faq.getDisplayOrder());
            stmt.setBoolean(5, faq.isActive());
            stmt.executeUpdate();
        }
    }

    // For admin: update FAQ
    public void updateFAQ(FAQ faq) throws SQLException {
        String sql = "UPDATE faqs SET question = ?, answer = ?, category = ?, display_order = ?, is_active = ?, updated_at = GETDATE() WHERE faq_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, faq.getQuestion());
            stmt.setString(2, faq.getAnswer());
            stmt.setString(3, faq.getCategory());
            stmt.setInt(4, faq.getDisplayOrder());
            stmt.setBoolean(5, faq.isActive());
            stmt.setInt(6, faq.getFaqId());
            stmt.executeUpdate();
        }
    }

    // For admin: delete FAQ
    public void deleteFAQ(int faqId) throws SQLException {
        String sql = "DELETE FROM faqs WHERE faq_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, faqId);
            stmt.executeUpdate();
        }
    }

    private FAQ mapResultSetToFAQ(ResultSet rs) throws SQLException {
        FAQ faq = new FAQ();
        faq.setFaqId(rs.getInt("faq_id"));
        faq.setQuestion(rs.getString("question"));
        faq.setAnswer(rs.getString("answer"));
        faq.setCategory(rs.getString("category"));
        faq.setDisplayOrder(rs.getInt("display_order"));
        faq.setActive(rs.getBoolean("is_active"));
        faq.setCreatedAt(rs.getTimestamp("created_at"));
        faq.setUpdatedAt(rs.getTimestamp("updated_at"));
        return faq;
    }
}