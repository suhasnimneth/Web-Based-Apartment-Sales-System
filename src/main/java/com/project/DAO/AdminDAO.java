package com.project.DAO;

import com.project.model.Admin;
import com.project.util.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    
    // Create a new admin
    public String createAdmin(Admin admin) {
        String sql = "INSERT INTO admins (username, email, password, firstName, lastName, phone, isActive, createdAt, updatedAt) " +
                     "OUTPUT INSERTED.adminId VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getPassword());
            stmt.setString(4, admin.getFirstName());
            stmt.setString(5, admin.getLastName());
            stmt.setString(6, admin.getPhone());
            stmt.setBoolean(7, admin.isActive());
            stmt.setTimestamp(8, Timestamp.valueOf(admin.getCreatedAt()));
            stmt.setTimestamp(9, Timestamp.valueOf(admin.getUpdatedAt()));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get admin by ID
    public Admin getAdminById(String adminId) {
        String sql = "SELECT * FROM admins WHERE adminId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, adminId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get admin by username
    public Admin getAdminByUsername(String username) {
        String sql = "SELECT * FROM admins WHERE username = ? AND isActive = 1";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin by username: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get admin by email
    public Admin getAdminByEmail(String email) {
        String sql = "SELECT * FROM admins WHERE email = ? AND isActive = 1";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Authenticate admin (login)
    public Admin authenticateAdmin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE (username = ? OR email = ?) AND password = ? AND isActive = 1";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = mapResultSetToAdmin(rs);
                    
                    // Update last login time
                    updateLastLogin(admin.getAdminId());
                    
                    return admin;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error authenticating admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Update admin
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET username = ?, email = ?, firstName = ?, lastName = ?, " +
                     "phone = ?, isActive = ?, updatedAt = ? WHERE adminId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getFirstName());
            stmt.setString(4, admin.getLastName());
            stmt.setString(5, admin.getPhone());
            stmt.setBoolean(6, admin.isActive());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(8, admin.getAdminId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update password
    public boolean updatePassword(String adminId, String newPassword) {
        String sql = "UPDATE admins SET password = ?, updatedAt = ? WHERE adminId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, adminId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update last login time
    public boolean updateLastLogin(String adminId) {
        String sql = "UPDATE admins SET lastLogin = ? WHERE adminId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(2, adminId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete admin (soft delete - set isActive to false)
    public boolean deleteAdmin(String adminId) {
        String sql = "UPDATE admins SET isActive = 0, updatedAt = ? WHERE adminId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(2, adminId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all admins
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admins ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    // Get active admins only
    public List<Admin> getActiveAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admins WHERE isActive = 1 ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting active admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    // Check if username exists
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM admins WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking username existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM admins WHERE email = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Helper method to map ResultSet to Admin object
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getString("adminId"));
        admin.setUsername(rs.getString("username"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        admin.setFirstName(rs.getString("firstName"));
        admin.setLastName(rs.getString("lastName"));
        admin.setPhone(rs.getString("phone"));
        admin.setActive(rs.getBoolean("isActive"));
        
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            admin.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) {
            admin.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        Timestamp lastLogin = rs.getTimestamp("lastLogin");
        if (lastLogin != null) {
            admin.setLastLogin(lastLogin.toLocalDateTime());
        }
        
        return admin;
    }
}
