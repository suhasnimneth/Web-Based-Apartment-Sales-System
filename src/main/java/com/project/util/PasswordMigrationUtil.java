package com.project.util;

import com.project.DAO.UserDAO;
import com.project.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class to migrate existing plain text passwords to hashed passwords
 * This should be run once to update existing users in the database
 */
public class PasswordMigrationUtil {
    
    private static final String SELECT_PLAIN_PASSWORDS = 
        "SELECT userId, password FROM users WHERE password NOT LIKE '%:%'";
    
    private static final String UPDATE_PASSWORD = 
        "UPDATE users SET password = ? WHERE userId = ?";
    
    /**
     * Migrates all plain text passwords to hashed passwords
     * @return Number of users migrated
     */
    public static int migratePasswords() {
        int migratedCount = 0;
        
        try (Connection conn = DBUtil.getConnection()) {
            // Get all users with plain text passwords
            List<UserPassword> plainPasswords = getPlainTextPasswords(conn);
            
            System.out.println("Found " + plainPasswords.size() + " users with plain text passwords");
            
            // Migrate each password
            for (UserPassword userPassword : plainPasswords) {
                String hashedPassword = PasswordUtil.hashPassword(userPassword.password);
                
                try (PreparedStatement stmt = conn.prepareStatement(UPDATE_PASSWORD)) {
                    stmt.setString(1, hashedPassword);
                    stmt.setString(2, userPassword.userId);
                    
                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        migratedCount++;
                        System.out.println("Migrated password for user: " + userPassword.userId);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error during password migration: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Password migration completed. Migrated " + migratedCount + " users.");
        return migratedCount;
    }
    
    /**
     * Gets all users with plain text passwords (passwords that don't contain ':')
     */
    private static List<UserPassword> getPlainTextPasswords(Connection conn) throws SQLException {
        List<UserPassword> plainPasswords = new ArrayList<>();
        
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_PLAIN_PASSWORDS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                UserPassword userPassword = new UserPassword();
                userPassword.userId = rs.getString("userId");
                userPassword.password = rs.getString("password");
                plainPasswords.add(userPassword);
            }
        }
        
        return plainPasswords;
    }
    
    /**
     * Inner class to hold user password data
     */
    private static class UserPassword {
        String userId;
        String password;
    }
    
    /**
     * Main method for running migration manually
     */
    public static void main(String[] args) {
        System.out.println("Starting password migration...");
        int migrated = migratePasswords();
        System.out.println("Migration completed. Migrated " + migrated + " passwords.");
    }
}
