package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.DAO.ApartmentDAO;
import com.project.DAO.ReviewDAO;
import com.project.DAO.BookingDAO;
import com.project.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/AdminReportsServlet")
public class AdminReportsServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private ApartmentDAO apartmentDAO;
    private ReviewDAO reviewDAO;
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        apartmentDAO = new ApartmentDAO();
        reviewDAO = new ReviewDAO();
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle export actions
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "export":
                    handleExport(request, response);
                    return;
                case "custom_report":
                    handleCustomReport(request, response);
                    return;
                default:
                    break;
            }
        }
        
        System.out.println("=== AdminReportsServlet.doGet() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Object admin = session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin not logged in, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        try {
            // Get overall statistics
            Map<String, Object> stats = getOverallStatistics();
            request.setAttribute("stats", stats);
            
            // Get user statistics
            Map<String, Object> userStats = getUserStatistics();
            request.setAttribute("userStats", userStats);
            
            // Get apartment statistics
            Map<String, Object> apartmentStats = getApartmentStatistics();
            request.setAttribute("apartmentStats", apartmentStats);
            
            // Get review statistics
            Map<String, Object> reviewStats = getReviewStatistics();
            request.setAttribute("reviewStats", reviewStats);
            
            // Get booking statistics
            Map<String, Object> bookingStats = getBookingStatistics();
            request.setAttribute("bookingStats", bookingStats);
            
            // Get recent activity
            List<Map<String, Object>> recentActivity = getRecentActivity();
            request.setAttribute("recentActivity", recentActivity);
            
            // Forward to reports page
            request.getRequestDispatcher("adminreports.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminReportsServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load reports page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }

    private void handleExport(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String dataset = request.getParameter("dataset"); // users|apartments|reviews|bookings
        if (dataset == null) dataset = "users";

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=" + dataset + "_export.csv");

        StringBuilder csv = new StringBuilder();

        try (Connection conn = DBUtil.getConnection()) {
            switch (dataset) {
                case "users": {
                    csv.append("userId,firstName,lastName,email,contactNumber,role,registrationDate\n");
                    String sql = "SELECT u.userId,u.firstName,u.lastName,u.email,u.contactNumber,u.role,u.registrationDate FROM users u ORDER BY u.registrationDate DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            csv.append(s(rs.getString("userId"))).append(',')
                               .append(s(rs.getString("firstName"))).append(',')
                               .append(s(rs.getString("lastName"))).append(',')
                               .append(s(rs.getString("email"))).append(',')
                               .append(s(rs.getString("contactNumber"))).append(',')
                               .append(s(rs.getString("role"))).append(',')
                               .append(s(rs.getString("registrationDate"))).append('\n');
                        }
                    }
                    break;
                }
                case "apartments": {
                    csv.append("apartmentId,title,city,status,price,bedrooms,bathrooms,areaSqFt,createdAt,sellerId\n");
                    String sql = "SELECT apartmentId,title,city,status,price,bedrooms,bathrooms,areaSqFt,createdAt,sellerId FROM apartments ORDER BY createdAt DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            csv.append(s(rs.getString("apartmentId"))).append(',')
                               .append(s(rs.getString("title"))).append(',')
                               .append(s(rs.getString("city"))).append(',')
                               .append(s(rs.getString("status"))).append(',')
                               .append(s(rs.getString("price"))).append(',')
                               .append(s(rs.getString("bedrooms"))).append(',')
                               .append(s(rs.getString("bathrooms"))).append(',')
                               .append(s(rs.getString("areaSqFt"))).append(',')
                               .append(s(rs.getString("createdAt"))).append(',')
                               .append(s(rs.getString("sellerId"))).append('\n');
                        }
                    }
                    break;
                }
                case "reviews": {
                    csv.append("reviewId,apartmentId,userId,rating,title,visible,createdAt\n");
                    String sql = "SELECT reviewId,apartmentId,userId,rating,title,isVisible,createdAt FROM reviews ORDER BY createdAt DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            csv.append(s(rs.getString("reviewId"))).append(',')
                               .append(s(rs.getString("apartmentId"))).append(',')
                               .append(s(rs.getString("userId"))).append(',')
                               .append(s(rs.getString("rating"))).append(',')
                               .append(s(rs.getString("title"))).append(',')
                               .append(s(rs.getString("isVisible"))).append(',')
                               .append(s(rs.getString("createdAt"))).append('\n');
                        }
                    }
                    break;
                }
                case "bookings": {
                    csv.append("bookingId,apartmentId,buyerId,status,amount,createdAt\n");
                    String sql = "SELECT bookingId,apartmentId,buyerId,status,amount,createdAt FROM bookings ORDER BY createdAt DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            csv.append(s(rs.getString("bookingId"))).append(',')
                               .append(s(rs.getString("apartmentId"))).append(',')
                               .append(s(rs.getString("buyerId"))).append(',')
                               .append(s(rs.getString("status"))).append(',')
                               .append(s(rs.getString("amount"))).append(',')
                               .append(s(rs.getString("createdAt"))).append('\n');
                        }
                    }
                    break;
                }
                default: {
                    csv.append("message\nNo dataset selected\n");
                }
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            csv.setLength(0);
            csv.append("error, ").append(s(e.getMessage()));
        }

        response.getWriter().write(csv.toString());
    }

    private void handleCustomReport(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=summary_report.csv");

        Map<String, Object> stats = getOverallStatistics();
        StringBuilder csv = new StringBuilder();
        csv.append("metric,value\n");
        for (Map.Entry<String, Object> entry : stats.entrySet()) {
            csv.append(s(entry.getKey())).append(',').append(s(String.valueOf(entry.getValue()))).append('\n');
        }
        response.getWriter().write(csv.toString());
    }

    private String s(String v) {
        if (v == null) return "";
        String esc = v.replace("\"", "\"\"");
        if (esc.contains(",") || esc.contains("\n") || esc.contains("\r")) {
            return '"' + esc + '"';
        }
        return esc;
    }
    
    private Map<String, Object> getOverallStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Total users
            String userCountSql = "SELECT COUNT(*) FROM users";
            try (PreparedStatement stmt = conn.prepareStatement(userCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalUsers", rs.getInt(1));
                }
            }
            
            // Total buyers
            String buyerCountSql = "SELECT COUNT(*) FROM buyers";
            try (PreparedStatement stmt = conn.prepareStatement(buyerCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalBuyers", rs.getInt(1));
                }
            }
            
            // Total sellers
            String sellerCountSql = "SELECT COUNT(*) FROM sellers";
            try (PreparedStatement stmt = conn.prepareStatement(sellerCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalSellers", rs.getInt(1));
                }
            }
            
            // Total apartments
            String apartmentCountSql = "SELECT COUNT(*) FROM apartments";
            try (PreparedStatement stmt = conn.prepareStatement(apartmentCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalApartments", rs.getInt(1));
                }
            }
            
            // Total reviews
            String reviewCountSql = "SELECT COUNT(*) FROM reviews";
            try (PreparedStatement stmt = conn.prepareStatement(reviewCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalReviews", rs.getInt(1));
                }
            }
            
            // Total bookings
            String bookingCountSql = "SELECT COUNT(*) FROM bookings";
            try (PreparedStatement stmt = conn.prepareStatement(bookingCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalBookings", rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting overall statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private Map<String, Object> getUserStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Users by role
            String roleStatsSql = "SELECT role, COUNT(*) as count FROM users GROUP BY role";
            try (PreparedStatement stmt = conn.prepareStatement(roleStatsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    stats.put("users_" + rs.getString("role"), rs.getInt("count"));
                }
            }
            
            // New users this month
            String newUsersSql = "SELECT COUNT(*) FROM users WHERE MONTH(registrationDate) = MONTH(GETDATE()) AND YEAR(registrationDate) = YEAR(GETDATE())";
            try (PreparedStatement stmt = conn.prepareStatement(newUsersSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("newUsersThisMonth", rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private Map<String, Object> getApartmentStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Apartments by city
            String cityStatsSql = "SELECT city, COUNT(*) as count FROM apartments GROUP BY city ORDER BY count DESC";
            List<Map<String, Object>> cityStats = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(cityStatsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> cityStat = new HashMap<>();
                    cityStat.put("city", rs.getString("city"));
                    cityStat.put("count", rs.getInt("count"));
                    cityStats.add(cityStat);
                }
            }
            stats.put("apartmentsByCity", cityStats);
            
            // Average price
            String avgPriceSql = "SELECT AVG(price) FROM apartments";
            try (PreparedStatement stmt = conn.prepareStatement(avgPriceSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("averagePrice", rs.getDouble(1));
                }
            }
            
            // New apartments this month
            String newApartmentsSql = "SELECT COUNT(*) FROM apartments WHERE MONTH(createdAt) = MONTH(GETDATE()) AND YEAR(createdAt) = YEAR(GETDATE())";
            try (PreparedStatement stmt = conn.prepareStatement(newApartmentsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("newApartmentsThisMonth", rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting apartment statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private Map<String, Object> getReviewStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Average rating
            String avgRatingSql = "SELECT AVG(CAST(rating AS FLOAT)) FROM reviews WHERE isVisible = 1";
            try (PreparedStatement stmt = conn.prepareStatement(avgRatingSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("averageRating", rs.getDouble(1));
                }
            }
            
            // Reviews by rating
            String ratingStatsSql = "SELECT rating, COUNT(*) as count FROM reviews WHERE isVisible = 1 GROUP BY rating ORDER BY rating";
            List<Map<String, Object>> ratingStats = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(ratingStatsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> ratingStat = new HashMap<>();
                    ratingStat.put("rating", rs.getInt("rating"));
                    ratingStat.put("count", rs.getInt("count"));
                    ratingStats.add(ratingStat);
                }
            }
            stats.put("reviewsByRating", ratingStats);
            
            // Visible vs Hidden reviews
            String visibleSql = "SELECT COUNT(*) FROM reviews WHERE isVisible = 1";
            try (PreparedStatement stmt = conn.prepareStatement(visibleSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("visibleReviews", rs.getInt(1));
                }
            }
            
            String hiddenSql = "SELECT COUNT(*) FROM reviews WHERE isVisible = 0";
            try (PreparedStatement stmt = conn.prepareStatement(hiddenSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("hiddenReviews", rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting review statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private Map<String, Object> getBookingStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Total bookings
            String totalBookingsSql = "SELECT COUNT(*) FROM bookings";
            try (PreparedStatement stmt = conn.prepareStatement(totalBookingsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalBookings", rs.getInt(1));
                }
            }
            
            // Bookings this month
            String monthlyBookingsSql = "SELECT COUNT(*) FROM bookings WHERE MONTH(createdAt) = MONTH(GETDATE()) AND YEAR(createdAt) = YEAR(GETDATE())";
            try (PreparedStatement stmt = conn.prepareStatement(monthlyBookingsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("bookingsThisMonth", rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting booking statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private List<Map<String, Object>> getRecentActivity() {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // Recent users
            String recentUsersSql = "SELECT TOP 5 'user' as type, firstName + ' ' + lastName as name, registrationDate as date FROM users ORDER BY registrationDate DESC";
            try (PreparedStatement stmt = conn.prepareStatement(recentUsersSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", "New User");
                    activity.put("name", rs.getString("name"));
                    activity.put("date", rs.getTimestamp("date"));
                    activities.add(activity);
                }
            }
            
            // Recent apartments
            String recentApartmentsSql = "SELECT TOP 5 'apartment' as type, title as name, createdAt as date FROM apartments ORDER BY createdAt DESC";
            try (PreparedStatement stmt = conn.prepareStatement(recentApartmentsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", "New Apartment");
                    activity.put("name", rs.getString("name"));
                    activity.put("date", rs.getTimestamp("date"));
                    activities.add(activity);
                }
            }
            
            // Recent reviews
            String recentReviewsSql = "SELECT TOP 5 'review' as type, title as name, createdAt as date FROM reviews ORDER BY createdAt DESC";
            try (PreparedStatement stmt = conn.prepareStatement(recentReviewsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", "New Review");
                    activity.put("name", rs.getString("name"));
                    activity.put("date", rs.getTimestamp("date"));
                    activities.add(activity);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting recent activity: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Sort by date (most recent first)
        activities.sort((a, b) -> {
            java.sql.Timestamp dateA = (java.sql.Timestamp) a.get("date");
            java.sql.Timestamp dateB = (java.sql.Timestamp) b.get("date");
            return dateB.compareTo(dateA);
        });
        
        return activities;
    }
}
