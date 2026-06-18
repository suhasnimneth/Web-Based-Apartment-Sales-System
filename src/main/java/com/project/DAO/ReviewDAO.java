package com.project.DAO;

import com.project.model.Review;
import com.project.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Create a new review
    public String createReview(Review review) {
        System.out.println("=== ReviewDAO.createReview ===");
        System.out.println("Creating review: " + review);
        
        String insertSql = "INSERT INTO reviews (buyerId, rating, title, reviewText, isVisible) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertSql)) {

            stmt.setString(1, review.getBuyerId());
            stmt.setInt(2, review.getRating());
            stmt.setString(3, review.getTitle());
            stmt.setString(4, review.getReviewText());
            stmt.setBoolean(5, review.isVisible());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                // Get the generated review ID
                String selectSql = "SELECT TOP 1 reviewId FROM reviews WHERE buyerId = ? ORDER BY createdAt DESC";
                
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setString(1, review.getBuyerId());
                    
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            String reviewId = rs.getString("reviewId");
                            System.out.println("✅ Review created successfully with ID: " + reviewId);
                            return reviewId;
                        }
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Exception in createReview:");
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        System.out.println("❌ Failed to create review");
        return null;
    }

    // Update an existing review
    public boolean updateReview(Review review) {
        System.out.println("=== ReviewDAO.updateReview ===");
        System.out.println("Updating review: " + review);
        
        String updateSql = "UPDATE reviews SET rating = ?, title = ?, reviewText = ?, isVisible = ?, updatedAt = GETDATE() WHERE reviewId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateSql)) {

            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getTitle());
            stmt.setString(3, review.getReviewText());
            stmt.setBoolean(4, review.isVisible());
            stmt.setString(5, review.getReviewId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("✅ Review updated successfully");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Exception in updateReview:");
            System.err.println("Error Message: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("❌ Failed to update review");
        return false;
    }

    // Get review by ID
    public Review getReviewById(String reviewId) {
        String sql = "SELECT r.reviewId, r.buyerId, r.rating, r.title, r.reviewText, r.isVisible, r.createdAt, r.updatedAt, " +
                   "u.firstName, u.lastName, u.email " +
                   "FROM reviews r " +
                   "JOIN buyers b ON r.buyerId = b.buyerId " +
                   "JOIN users u ON b.userId = u.userId " +
                   "WHERE r.reviewId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, reviewId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getString("reviewId"));
                review.setBuyerId(rs.getString("buyerId"));
                review.setRating(rs.getInt("rating"));
                review.setTitle(rs.getString("title"));
                review.setReviewText(rs.getString("reviewText"));
                review.setVisible(rs.getBoolean("isVisible"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) review.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) review.setUpdatedAt(updatedAt.toLocalDateTime());
                
                review.setBuyerName(rs.getString("firstName") + " " + rs.getString("lastName"));
                review.setBuyerEmail(rs.getString("email"));

                return review;
            }
        } catch (SQLException e) {
            System.err.println("Error getting review by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Get review by buyer ID
    public Review getReviewByBuyerId(String buyerId) {
        String sql = "SELECT r.reviewId, r.buyerId, r.rating, r.title, r.reviewText, r.isVisible, r.createdAt, r.updatedAt, " +
                   "u.firstName, u.lastName, u.email " +
                   "FROM reviews r " +
                   "JOIN buyers b ON r.buyerId = b.buyerId " +
                   "JOIN users u ON b.userId = u.userId " +
                   "WHERE r.buyerId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getString("reviewId"));
                review.setBuyerId(rs.getString("buyerId"));
                review.setRating(rs.getInt("rating"));
                review.setTitle(rs.getString("title"));
                review.setReviewText(rs.getString("reviewText"));
                review.setVisible(rs.getBoolean("isVisible"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) review.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) review.setUpdatedAt(updatedAt.toLocalDateTime());
                
                review.setBuyerName(rs.getString("firstName") + " " + rs.getString("lastName"));
                review.setBuyerEmail(rs.getString("email"));

                return review;
            }
        } catch (SQLException e) {
            System.err.println("Error getting review by buyer ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Get all visible reviews for display
    public List<Review> getAllVisibleReviews() {
        String sql = "SELECT r.reviewId, r.buyerId, r.rating, r.title, r.reviewText, r.isVisible, r.createdAt, r.updatedAt, " +
                   "u.firstName, u.lastName, u.email " +
                   "FROM reviews r " +
                   "JOIN buyers b ON r.buyerId = b.buyerId " +
                   "JOIN users u ON b.userId = u.userId " +
                   "WHERE r.isVisible = 1 " +
                   "ORDER BY r.createdAt DESC";

        List<Review> reviews = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getString("reviewId"));
                review.setBuyerId(rs.getString("buyerId"));
                review.setRating(rs.getInt("rating"));
                review.setTitle(rs.getString("title"));
                review.setReviewText(rs.getString("reviewText"));
                review.setVisible(rs.getBoolean("isVisible"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) review.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) review.setUpdatedAt(updatedAt.toLocalDateTime());
                
                review.setBuyerName(rs.getString("firstName") + " " + rs.getString("lastName"));
                review.setBuyerEmail(rs.getString("email"));

                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all visible reviews: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    // Get average rating
    public double getAverageRating() {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) as avgRating FROM reviews WHERE isVisible = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avgRating");
            }
        } catch (SQLException e) {
            System.err.println("Error getting average rating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    // Get total review count
    public int getTotalReviewCount() {
        String sql = "SELECT COUNT(*) as totalReviews FROM reviews WHERE isVisible = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalReviews");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total review count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Delete review
    public boolean deleteReview(String reviewId) {
        String sql = "DELETE FROM reviews WHERE reviewId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, reviewId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Get all reviews
    public List<Review> getAllReviews() {
        String sql = "SELECT r.reviewId, r.buyerId, r.rating, r.title, r.reviewText, r.isVisible, r.createdAt, r.updatedAt, " +
                   "u.firstName, u.lastName, u.email " +
                   "FROM reviews r " +
                   "JOIN buyers b ON r.buyerId = b.buyerId " +
                   "JOIN users u ON b.userId = u.userId " +
                   "ORDER BY r.createdAt DESC";

        List<Review> reviews = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getString("reviewId"));
                    review.setBuyerId(rs.getString("buyerId"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setReviewText(rs.getString("reviewText"));
                    review.setVisible(rs.getBoolean("isVisible"));
                    review.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    review.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
                    
                    // Set buyer name for display
                    review.setBuyerName(rs.getString("firstName") + " " + rs.getString("lastName"));
                    
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all reviews: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    // Get total number of reviews
    public int getTotalReviews() {
        String sql = "SELECT COUNT(*) FROM reviews";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting total reviews: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
