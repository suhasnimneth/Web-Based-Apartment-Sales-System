<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.DAO.ReviewDAO" %>
<%@ page import="com.project.util.DBUtil" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Review System Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-result { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
    </style>
</head>
<body>
    <h1>Review System Test</h1>
    
    <%
        try {
            // Test 1: Database Connection
            out.println("<h2>1. Database Connection Test</h2>");
            try (Connection conn = DBUtil.getConnection()) {
                out.println("<div class='test-result success'>✅ Database connection successful</div>");
            } catch (Exception e) {
                out.println("<div class='test-result error'>❌ Database connection failed: " + e.getMessage() + "</div>");
            }
            
            // Test 2: Check if reviews table exists
            out.println("<h2>2. Reviews Table Check</h2>");
            try (Connection conn = DBUtil.getConnection()) {
                String checkTableSql = "SELECT COUNT(*) FROM reviews";
                try (PreparedStatement stmt = conn.prepareStatement(checkTableSql)) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<div class='test-result success'>✅ Reviews table exists with " + count + " records</div>");
                    }
                }
            } catch (SQLException e) {
                if (e.getMessage().contains("Invalid object name 'reviews'")) {
                    out.println("<div class='test-result error'>❌ Reviews table does not exist. Please run the SQL script first.</div>");
                } else {
                    out.println("<div class='test-result error'>❌ Error checking reviews table: " + e.getMessage() + "</div>");
                }
            }
            
            // Test 3: ReviewDAO Test
            out.println("<h2>3. ReviewDAO Test</h2>");
            try {
                ReviewDAO reviewDAO = new ReviewDAO();
                int totalReviews = reviewDAO.getTotalReviewCount();
                double avgRating = reviewDAO.getAverageRating();
                out.println("<div class='test-result success'>✅ ReviewDAO working - Total reviews: " + totalReviews + ", Average rating: " + String.format("%.1f", avgRating) + "</div>");
            } catch (Exception e) {
                out.println("<div class='test-result error'>❌ ReviewDAO error: " + e.getMessage() + "</div>");
            }
            
            // Test 4: Session Test
            out.println("<h2>4. Session Test</h2>");
            Object user = session.getAttribute("user");
            String userRole = (String) session.getAttribute("userRole");
            if (user != null) {
                out.println("<div class='test-result success'>✅ User logged in: " + user.toString() + "</div>");
                out.println("<div class='test-result info'>ℹ️ User role: " + userRole + "</div>");
            } else {
                out.println("<div class='test-result error'>❌ No user logged in. Please login as a buyer to test reviews.</div>");
            }
            
        } catch (Exception e) {
            out.println("<div class='test-result error'>❌ General error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
    %>
    
    <h2>Next Steps</h2>
    <ol>
        <li>If the reviews table doesn't exist, run the SQL script to create it</li>
        <li>If you're not logged in, login as a buyer</li>
        <li>Try submitting a review again</li>
        <li>Check the browser console and server logs for detailed error messages</li>
    </ol>
    
    <h2>Servlet Test</h2>
    <p><a href="ReviewServlet?test=true" target="_blank">Test ReviewServlet Parameter Reception</a></p>
    
    <p><a href="addreview.jsp">← Back to Add Review</a></p>
</body>
</html>
