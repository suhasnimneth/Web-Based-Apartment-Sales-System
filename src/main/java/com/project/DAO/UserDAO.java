package com.project.DAO;

import com.project.model.Buyer;
import com.project.model.Seller;
import com.project.model.User;
import com.project.util.DBUtil;
import com.project.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Insert user into users table; returns generated userId (e.g., U001)
    public String insertUser(User user) {
        String sql = "INSERT INTO users (firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate) OUTPUT INSERTED.userId VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName());
            stmt.setString(3, user.getContactNumber());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getEmail());
            
            // Hash the password before storing
            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            stmt.setString(6, hashedPassword);
            
            stmt.setDate(7, Date.valueOf(user.getDateOfBirth()));
            stmt.setString(8, user.getRole());
            stmt.setTimestamp(9, Timestamp.valueOf(user.getRegistrationDate().atStartOfDay()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert buyer into buyers table
    public boolean insertBuyer(String userId, Buyer buyer) {
        String sql = "INSERT INTO buyers (userId, preferredLocation, budgetRange, purchaseTimeline) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            stmt.setString(2, buyer.getPreferredLocation());
            if (buyer.getBudgetRange() != null) {
                stmt.setBigDecimal(3, java.math.BigDecimal.valueOf(buyer.getBudgetRange()));
            } else {
                stmt.setNull(3, Types.DECIMAL);
            }
            stmt.setString(4, buyer.getPurchaseTimeline());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Insert seller into sellers table
    public boolean insertSeller(String userId, Seller seller) {
        String sql = "INSERT INTO sellers (userId, businessRegistrationNumber, companyName, licenseNumber) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            stmt.setString(2, seller.getBusinessRegistrationNumber());
            stmt.setString(3, seller.getCompanyName());
            stmt.setString(4, seller.getLicenseNumber());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if email already exists
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Authentication
    public User authenticateUser(String email, String password, String role) {
        String sql = "SELECT userId, firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate FROM users WHERE email = ? AND role = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, role);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Verify the password using the stored hash
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setContactNumber(rs.getString("contactNumber"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                    user.setPassword(storedPassword); // Store the hashed password
                user.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime().toLocalDate());

                return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Authentication without role; determine role from DB
    public User authenticateUser(String email, String password) {
        String sql = "SELECT userId, firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate FROM users WHERE email = ?";

        System.out.println("UserDAO.authenticateUser called with email: " + email);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            System.out.println("Database connection established, preparing statement...");
            stmt.setString(1, email);

            System.out.println("Executing query...");
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Verify the password using the stored hash
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setContactNumber(rs.getString("contactNumber"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                    user.setPassword(storedPassword); // Store the hashed password
                user.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime().toLocalDate());

                return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in authenticateUser: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        System.out.println("No user found or error occurred, returning null");
        return null;
    }

    // Method to check if user exists by email and role
    public boolean userExists(String email, String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND role = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, role);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExistsForOtherUsers(String email, String currentUserId) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND userId != ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, currentUserId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(String userId) {
        String sql = "SELECT userId, firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate FROM users WHERE userId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setContactNumber(rs.getString("contactNumber"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime().toLocalDate());

                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Helper: fetch sellerId (Sxxx) by users.userId (Uxxx)
    public String getSellerIdByUserId(String userId) {
        String sql = "SELECT sellerId FROM sellers WHERE userId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Helper: fetch buyerId (Bxxx) by users.userId (Uxxx)
    public String getBuyerIdByUserId(String userId) {
        System.out.println("=== UserDAO.getBuyerIdByUserId() called ===");
        System.out.println("Looking for buyerId with userId: " + userId);
        
        String sql = "SELECT buyerId FROM buyers WHERE userId = ?";
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String buyerId = rs.getString(1);
                    System.out.println("Found buyerId: " + buyerId);
                    return buyerId;
                } else {
                    System.out.println("No buyerId found for userId: " + userId);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in getBuyerIdByUserId:");
            e.printStackTrace();
        }
        System.out.println("Returning null from getBuyerIdByUserId");
        return null;
    }

    // Helper: fetch userId (Uxxx) by sellers.sellerId (Sxxx)
    public String getUserIdBySellerId(String sellerId) {
        String sql = "SELECT userId FROM sellers WHERE sellerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Helper: fetch userId (Uxxx) by buyers.buyerId (Bxxx)
    public String getUserIdByBuyerId(String buyerId) {
        String sql = "SELECT userId FROM buyers WHERE buyerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get seller name by seller ID
    public String getSellerNameBySellerId(String sellerId) {
        String sql = "SELECT u.firstName, u.lastName FROM users u " +
                   "JOIN sellers s ON u.userId = s.userId " +
                   "WHERE s.sellerId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("firstName") + " " + rs.getString("lastName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown Seller";
    }

    // Get all users
    public List<User> getAllUsers() {
        String sql = "SELECT userId, firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate FROM users ORDER BY registrationDate DESC";
        
        List<User> users = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getString("userId"));
                    user.setFirstName(rs.getString("firstName"));
                    user.setLastName(rs.getString("lastName"));
                    user.setContactNumber(rs.getString("contactNumber"));
                    user.setAddress(rs.getString("address"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime().toLocalDate());
                    
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Delete user (handles all foreign key constraints manually)
    public boolean deleteUser(String userId) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try {
                // Get buyer and seller IDs first
                String buyerId = getBuyerIdByUserId(userId);
                String sellerId = getSellerIdByUserId(userId);
                
                // Delete all related records for buyer
                if (buyerId != null) {
                    // Delete buyer cards (CASCADE constraint)
                    String deleteBuyerCardsSql = "DELETE FROM buyerCards WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteBuyerCardsSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete payments (NO ACTION constraint - must delete manually)
                    String deletePaymentsSql = "DELETE FROM payments WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deletePaymentsSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete bookings (no foreign key constraints in current schema)
                    String deleteBookingsSql = "DELETE FROM bookings WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteBookingsSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete favourites (CASCADE constraint)
                    String deleteFavouritesSql = "DELETE FROM favourites WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteFavouritesSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete reviews (CASCADE constraint)
                    String deleteReviewsSql = "DELETE FROM reviews WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteReviewsSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete buyer record (CASCADE constraint)
                    String deleteBuyerSql = "DELETE FROM buyers WHERE buyerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteBuyerSql)) {
                        stmt.setString(1, buyerId);
                        stmt.executeUpdate();
                    }
                }
                
                // Delete all related records for seller
                if (sellerId != null) {
                    // Delete apartment images first (CASCADE constraint)
                    String deleteApartmentImagesSql = "DELETE FROM apartment_images WHERE apartmentId IN (SELECT apartmentId FROM apartments WHERE sellerId = ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteApartmentImagesSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete favourites for seller's apartments (NO ACTION constraint - must delete manually)
                    String deleteFavouritesSql = "DELETE FROM favourites WHERE apartmentId IN (SELECT apartmentId FROM apartments WHERE sellerId = ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteFavouritesSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete bookings for seller's apartments (no foreign key constraints)
                    String deleteBookingsSql = "DELETE FROM bookings WHERE apartmentId IN (SELECT apartmentId FROM apartments WHERE sellerId = ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteBookingsSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete payments for seller (NO ACTION constraint - must delete manually)
                    String deletePaymentsSql = "DELETE FROM payments WHERE sellerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deletePaymentsSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete apartments (CASCADE constraint)
                    String deleteApartmentsSql = "DELETE FROM apartments WHERE sellerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteApartmentsSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                    
                    // Delete seller record (CASCADE constraint)
                    String deleteSellerSql = "DELETE FROM sellers WHERE sellerId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(deleteSellerSql)) {
                        stmt.setString(1, sellerId);
                        stmt.executeUpdate();
                    }
                }
                
                // Finally delete the user
                String deleteUserSql = "DELETE FROM users WHERE userId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteUserSql)) {
                    stmt.setString(1, userId);
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        conn.commit(); // Commit transaction
                        return true;
                    } else {
                        conn.rollback(); // Rollback if no user found
                        return false;
                    }
                }
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}