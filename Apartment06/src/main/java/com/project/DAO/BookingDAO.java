package com.project.DAO;

import com.project.model.Booking;
import com.project.util.DBUtil;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    // Create a new booking
    public String createBooking(Booking booking) {
        System.out.println("=== BookingDAO.createBooking ===");
        System.out.println("Creating booking: " + booking);
        
        String insertSql = "INSERT INTO bookings (buyerId, sellerId, apartmentId, bookingDate, bookingTime, message, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String bookingId = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            // Get database connection
            System.out.println("Getting database connection...");
            conn = DBUtil.getConnection();
            if (conn == null) {
                throw new SQLException("Database connection is null");
            }
            System.out.println("✅ Database connection established");
            
            // Prepare statement
            System.out.println("Preparing insert statement...");
            stmt = conn.prepareStatement(insertSql);
            System.out.println("✅ Insert statement prepared");
            
            // Set parameters
            System.out.println("Setting parameters...");
            stmt.setString(1, booking.getBuyerId());
            stmt.setString(2, booking.getSellerId());
            stmt.setString(3, booking.getApartmentId());
            stmt.setDate(4, Date.valueOf(booking.getBookingDate()));
            stmt.setTime(5, Time.valueOf(booking.getBookingTime()));
            stmt.setString(6, booking.getMessage());
            stmt.setString(7, booking.getStatus());
            System.out.println("✅ Parameters set successfully");
            
            // Execute insert
            System.out.println("Executing insert statement...");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("✅ Insert executed successfully");
                
                // Retrieve generated booking ID
                System.out.println("Retrieving generated booking ID...");
                bookingId = retrieveGeneratedBookingId(conn, booking);
                if (bookingId != null) {
                    System.out.println("✅ Booking created successfully with ID: " + bookingId);
                } else {
                    System.err.println("❌ Failed to retrieve generated booking ID");
                }
            } else {
                System.err.println("❌ No rows affected by insert statement");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Exception in createBooking:");
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            
            // Handle specific SQL errors
            if (e.getErrorCode() == 2627 || e.getSQLState().equals("23000")) {
                System.err.println("❌ Duplicate booking - time slot already booked");
                return "duplicate_booking";
            } else if (e.getErrorCode() == 547) {
                System.err.println("❌ Foreign key constraint violation");
                return "foreign_key_error";
            } else if (e.getErrorCode() == 515) {
                System.err.println("❌ Cannot insert NULL value into required column");
                return "null_value_error";
            } else {
                System.err.println("❌ Unknown SQL error occurred");
                return "sql_error";
            }
        } catch (Exception e) {
            System.err.println("❌ General Exception in createBooking:");
            System.err.println("Exception type: " + e.getClass().getSimpleName());
            System.err.println("Exception message: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            return "general_error";
        } finally {
            // Clean up resources
            System.out.println("Cleaning up resources...");
            try {
                if (stmt != null) {
                    stmt.close();
                    System.out.println("✅ PreparedStatement closed");
                }
                if (conn != null) {
                    conn.close();
                    System.out.println("✅ Connection closed");
                }
            } catch (SQLException e) {
                System.err.println("❌ Error closing resources: " + e.getMessage());
            }
        }
        
        if (bookingId == null) {
            System.out.println("❌ Failed to create booking or retrieve booking ID");
            return "creation_failed";
        }
        
        return bookingId;
    }
    
    // Helper method to retrieve generated booking ID
    private String retrieveGeneratedBookingId(Connection conn, Booking booking) {
        String selectSql = "SELECT bookingId FROM bookings WHERE buyerId = ? AND apartmentId = ? AND bookingDate = ? AND CAST(bookingTime AS TIME) = ? ORDER BY createdAt DESC";
        PreparedStatement selectStmt = null;
        ResultSet rs = null;
        
        try {
            selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, booking.getBuyerId());
            selectStmt.setString(2, booking.getApartmentId());
            selectStmt.setDate(3, Date.valueOf(booking.getBookingDate()));
            selectStmt.setTime(4, Time.valueOf(booking.getBookingTime()));
            
            rs = selectStmt.executeQuery();
            if (rs.next()) {
                return rs.getString("bookingId");
            }
        } catch (SQLException e) {
            System.err.println("❌ Error retrieving booking ID: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (selectStmt != null) selectStmt.close();
            } catch (SQLException e) {
                System.err.println("❌ Error closing select resources: " + e.getMessage());
            }
        }
        return null;
    }
    
    // Check for booking conflicts
    public boolean hasBookingConflict(String apartmentId, LocalDate bookingDate, LocalTime bookingTime) {
        System.out.println("=== BookingDAO.hasBookingConflict ===");
        
        String sql = "SELECT COUNT(*) FROM bookings WHERE apartmentId = ? AND bookingDate = ? AND CAST(bookingTime AS TIME) = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, apartmentId);
            stmt.setDate(2, Date.valueOf(bookingDate));
            stmt.setTime(3, Time.valueOf(bookingTime));
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Conflict check result: " + count + " existing bookings");
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking booking conflict: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }
    
    // Get booking by ID
    public Booking getBookingById(String bookingId) {
        String sql = "SELECT bookingId, buyerId, sellerId, apartmentId, bookingDate, bookingTime, message, status, createdAt, updatedAt FROM bookings WHERE bookingId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("bookingId"));
                booking.setBuyerId(rs.getString("buyerId"));
                booking.setSellerId(rs.getString("sellerId"));
                booking.setApartmentId(rs.getString("apartmentId"));
                booking.setBookingDate(rs.getDate("bookingDate").toLocalDate());
                booking.setBookingTime(rs.getTime("bookingTime").toLocalTime());
                booking.setMessage(rs.getString("message"));
                booking.setStatus(rs.getString("status"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) booking.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) booking.setUpdatedAt(updatedAt.toLocalDateTime());
                
                return booking;
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking by ID: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return null;
    }
    
    // Get all bookings for a buyer
    public List<Booking> getBookingsByBuyer(String buyerId) {
        String sql = "SELECT b.bookingId, b.buyerId, b.sellerId, b.apartmentId, b.bookingDate, b.bookingTime, b.message, b.status, b.createdAt, b.updatedAt, " +
                   "a.title, a.price, a.city, a.address " +
                   "FROM bookings b " +
                   "JOIN apartments a ON b.apartmentId = a.apartmentId " +
                   "WHERE b.buyerId = ? " +
                   "ORDER BY b.createdAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("bookingId"));
                booking.setBuyerId(rs.getString("buyerId"));
                booking.setSellerId(rs.getString("sellerId"));
                booking.setApartmentId(rs.getString("apartmentId"));
                booking.setBookingDate(rs.getDate("bookingDate").toLocalDate());
                booking.setBookingTime(rs.getTime("bookingTime").toLocalTime());
                booking.setMessage(rs.getString("message"));
                booking.setStatus(rs.getString("status"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) booking.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) booking.setUpdatedAt(updatedAt.toLocalDateTime());
                
                // Set apartment details
                booking.setApartmentTitle(rs.getString("title"));
                booking.setApartmentAddress(rs.getString("address"));
                booking.setApartmentCity(rs.getString("city"));
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("Error getting bookings by buyer: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return bookings;
    }
    
    // Get all bookings for a seller's apartments
    public List<Booking> getBookingsBySeller(String sellerId) {
        String sql = "SELECT b.bookingId, b.buyerId, b.sellerId, b.apartmentId, b.bookingDate, b.bookingTime, b.message, b.status, b.createdAt, b.updatedAt, " +
                   "a.title, a.price, a.city, a.address, " +
                   "u.firstName, u.lastName, u.email " +
                   "FROM bookings b " +
                   "JOIN apartments a ON b.apartmentId = a.apartmentId " +
                   "JOIN buyers bu ON b.buyerId = bu.buyerId " +
                   "JOIN users u ON bu.userId = u.userId " +
                   "WHERE a.sellerId = ? " +
                   "ORDER BY b.createdAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("bookingId"));
                booking.setBuyerId(rs.getString("buyerId"));
                booking.setSellerId(rs.getString("sellerId"));
                booking.setApartmentId(rs.getString("apartmentId"));
                booking.setBookingDate(rs.getDate("bookingDate").toLocalDate());
                booking.setBookingTime(rs.getTime("bookingTime").toLocalTime());
                booking.setMessage(rs.getString("message"));
                booking.setStatus(rs.getString("status"));
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) booking.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) booking.setUpdatedAt(updatedAt.toLocalDateTime());
                
                // Set apartment details
                booking.setApartmentTitle(rs.getString("title"));
                booking.setApartmentAddress(rs.getString("address"));
                booking.setApartmentCity(rs.getString("city"));
                
                // Set buyer details
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                booking.setBuyerName(firstName + " " + lastName);
                booking.setBuyerEmail(rs.getString("email"));
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("Error getting bookings by seller: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return bookings;
    }
    
    // Update booking status
    public boolean updateBookingStatus(String bookingId, String status) {
        String sql = "UPDATE bookings SET status = ?, updatedAt = ? WHERE bookingId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, bookingId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating booking status: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            return false;
        }
    }
    
    // Delete booking
    public boolean deleteBooking(String bookingId) {
        String sql = "DELETE FROM bookings WHERE bookingId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, bookingId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting booking: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            return false;
        }
    }
    
    // Get booking count by buyer
    public int getBookingCountByBuyer(String buyerId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE buyerId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking count by buyer: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return 0;
    }
    
    // Get pending booking count by buyer
    public int getPendingBookingCountByBuyer(String buyerId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE buyerId = ? AND status = 'Pending'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting pending booking count by buyer: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return 0;
    }
    
    // Get booking count by seller
    public int getBookingCountBySeller(String sellerId) {
        String sql = "SELECT COUNT(*) FROM bookings b JOIN apartments a ON b.apartmentId = a.apartmentId WHERE a.sellerId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking count by seller: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return 0;
    }
    
    // Get pending booking count by seller
    public int getPendingBookingCountBySeller(String sellerId) {
        String sql = "SELECT COUNT(*) FROM bookings b JOIN apartments a ON b.apartmentId = a.apartmentId WHERE a.sellerId = ? AND b.status = 'Pending'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting pending booking count by seller: " + e.getMessage());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return 0;
    }
}
