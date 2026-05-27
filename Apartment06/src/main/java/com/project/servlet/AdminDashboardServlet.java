package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.DAO.ApartmentDAO;
import com.project.DAO.ReviewDAO;
import com.project.DAO.BookingDAO;
import com.project.model.Admin;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    
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
        
        System.out.println("=== AdminDashboardServlet.doGet() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin not logged in, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        try {
            // Get dashboard statistics
            Map<String, Object> stats = getDashboardStatistics();
            System.out.println("Dashboard statistics loaded: " + stats);
            request.setAttribute("stats", stats);
            request.setAttribute("currentPage", "dashboard");
            
            // Forward to dashboard
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminDashboardServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
        }
    }
    
    private Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new HashMap<>();
        System.out.println("Getting dashboard statistics...");
        
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Database connection established");
            
            // Total users
            String userCountSql = "SELECT COUNT(*) FROM users";
            try (PreparedStatement stmt = conn.prepareStatement(userCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalUsers", rs.getInt(1));
                    System.out.println("Total users: " + rs.getInt(1));
                }
            }
            
            // Total apartments
            String apartmentCountSql = "SELECT COUNT(*) FROM apartments";
            try (PreparedStatement stmt = conn.prepareStatement(apartmentCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalApartments", rs.getInt(1));
                    System.out.println("Total apartments: " + rs.getInt(1));
                }
            }
            
            // Total bookings
            String bookingCountSql = "SELECT COUNT(*) FROM bookings";
            try (PreparedStatement stmt = conn.prepareStatement(bookingCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalBookings", rs.getInt(1));
                    System.out.println("Total bookings: " + rs.getInt(1));
                }
            }
            
            // Total reviews
            String reviewCountSql = "SELECT COUNT(*) FROM reviews";
            try (PreparedStatement stmt = conn.prepareStatement(reviewCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalReviews", rs.getInt(1));
                    System.out.println("Total reviews: " + rs.getInt(1));
                }
            }
            
            // Recent activity counts
            String recentUsersSql = "SELECT COUNT(*) FROM users WHERE DATEDIFF(day, registrationDate, GETDATE()) <= 7";
            try (PreparedStatement stmt = conn.prepareStatement(recentUsersSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("recentUsers", rs.getInt(1));
                    System.out.println("Recent users: " + rs.getInt(1));
                }
            }
            
            String recentApartmentsSql = "SELECT COUNT(*) FROM apartments WHERE DATEDIFF(day, createdAt, GETDATE()) <= 7";
            try (PreparedStatement stmt = conn.prepareStatement(recentApartmentsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("recentApartments", rs.getInt(1));
                    System.out.println("Recent apartments: " + rs.getInt(1));
                }
            }
            
            String recentBookingsSql = "SELECT COUNT(*) FROM bookings WHERE DATEDIFF(day, createdAt, GETDATE()) <= 7";
            try (PreparedStatement stmt = conn.prepareStatement(recentBookingsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("recentBookings", rs.getInt(1));
                    System.out.println("Recent bookings: " + rs.getInt(1));
                }
            }
            
            String recentReviewsSql = "SELECT COUNT(*) FROM reviews WHERE DATEDIFF(day, createdAt, GETDATE()) <= 7";
            try (PreparedStatement stmt = conn.prepareStatement(recentReviewsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("recentReviews", rs.getInt(1));
                    System.out.println("Recent reviews: " + rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting dashboard statistics: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values if database error
            stats.put("totalUsers", 0);
            stats.put("totalApartments", 0);
            stats.put("totalBookings", 0);
            stats.put("totalReviews", 0);
            stats.put("recentUsers", 0);
            stats.put("recentApartments", 0);
            stats.put("recentBookings", 0);
            stats.put("recentReviews", 0);
        }
        
        return stats;
    }
}
