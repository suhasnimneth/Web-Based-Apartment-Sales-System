package com.project.DAO;

//Adding a new payment
//Fetching payments for buyers/sellers/apartments
//Updating payment status
//Checking and deducting card balances
//Calculating totals and counts

import com.project.model.Payment;
import com.project.util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    // Add a new payment
    public String addPayment(Payment payment) {
        System.out.println("=== PaymentDAO.addPayment ===");
        System.out.println("Payment details:");
        System.out.println("  buyerId: " + payment.getBuyerId());
        System.out.println("  sellerId: " + payment.getSellerId());
        System.out.println("  apartmentId: " + payment.getApartmentId());
        System.out.println("  buyerCardId: " + payment.getBuyerCardId());
        System.out.println("  paymentType: " + payment.getPaymentType());
        System.out.println("  amount: " + payment.getAmount());
        System.out.println("  status: " + payment.getStatus());
        System.out.println("  description: " + payment.getDescription());
        
        String sql = "INSERT INTO payments (buyerId, sellerId, apartmentId, buyerCardId, paymentType, amount, status, description) OUTPUT INSERTED.paymentId VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        System.out.println("SQL: " + sql);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("Database connection established");

            stmt.setString(1, payment.getBuyerId());
            stmt.setString(2, payment.getSellerId());
            stmt.setString(3, payment.getApartmentId());
            stmt.setString(4, payment.getBuyerCardId());
            stmt.setString(5, payment.getPaymentType());
            stmt.setBigDecimal(6, payment.getAmount());
            stmt.setString(7, payment.getStatus());
            stmt.setString(8, payment.getDescription());

            System.out.println("Parameters set, executing query...");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String paymentId = rs.getString(1);
                    System.out.println("Payment created successfully with ID: " + paymentId);
                    return paymentId;
                } else {
                    System.out.println("No payment ID returned from database");
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception in addPayment: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning null from addPayment");
        return null;
    }

    // Get all payments for a buyer
    public List<Payment> getPaymentsByBuyerId(String buyerId) {
        String sql = "SELECT paymentId, buyerId, sellerId, apartmentId, buyerCardId, paymentType, amount, status, paymentDate, description, createdAt, updatedAt FROM payments WHERE buyerId = ? ORDER BY createdAt DESC";

        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Get all payments for a seller
    public List<Payment> getPaymentsBySellerId(String sellerId) {
        String sql = "SELECT paymentId, buyerId, sellerId, apartmentId, buyerCardId, paymentType, amount, status, paymentDate, description, createdAt, updatedAt FROM payments WHERE sellerId = ? ORDER BY createdAt DESC";

        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Get payments for a specific apartment
    public List<Payment> getPaymentsByApartmentId(String apartmentId) {
        String sql = "SELECT paymentId, buyerId, sellerId, apartmentId, buyerCardId, paymentType, amount, status, paymentDate, description, createdAt, updatedAt FROM payments WHERE apartmentId = ? ORDER BY createdAt DESC";

        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, apartmentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Get a specific payment by ID
    public Payment getPaymentById(String paymentId) {
        String sql = "SELECT paymentId, buyerId, sellerId, apartmentId, buyerCardId, paymentType, amount, status, paymentDate, description, createdAt, updatedAt FROM payments WHERE paymentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPayment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update payment status
    public boolean updatePaymentStatus(String paymentId, String status) {
        String sql = "UPDATE payments SET status = ?, updatedAt = SYSUTCDATETIME() WHERE paymentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, paymentId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if buyer has sufficient balance in card
    public boolean hasSufficientBalance(String buyerCardId, BigDecimal requiredAmount) {
        System.out.println("=== PaymentDAO.hasSufficientBalance ===");
        System.out.println("buyerCardId: " + buyerCardId);
        System.out.println("requiredAmount: " + requiredAmount);
        
        String sql = "SELECT amountInCard FROM buyerCards WHERE buyerCardId = ?";
        System.out.println("SQL: " + sql);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCardId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                BigDecimal cardBalance = rs.getBigDecimal("amountInCard");
                System.out.println("Card balance: " + cardBalance);
                boolean sufficient = cardBalance != null && cardBalance.compareTo(requiredAmount) >= 0;
                System.out.println("Sufficient balance: " + sufficient);
                return sufficient;
            } else {
                System.out.println("No card found with ID: " + buyerCardId);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception in hasSufficientBalance: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning false from hasSufficientBalance");
        return false;
    }

    // Deduct amount from card balance
    public boolean deductFromCard(String buyerCardId, BigDecimal amount) {
        System.out.println("=== PaymentDAO.deductFromCard ===");
        System.out.println("buyerCardId: " + buyerCardId);
        System.out.println("amount: " + amount);
        
        String sql = "UPDATE buyerCards SET amountInCard = amountInCard - ?, updatedAt = SYSUTCDATETIME() WHERE buyerCardId = ? AND amountInCard >= ?";
        System.out.println("SQL: " + sql);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, amount);
            stmt.setString(2, buyerCardId);
            stmt.setBigDecimal(3, amount);

            System.out.println("Executing update query...");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Exception in deductFromCard: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Check if payment belongs to buyer
    public boolean isPaymentOwnedByBuyer(String paymentId, String buyerId) {
        String sql = "SELECT COUNT(*) FROM payments WHERE paymentId = ? AND buyerId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentId);
            stmt.setString(2, buyerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check if payment belongs to seller
    public boolean isPaymentOwnedBySeller(String paymentId, String sellerId) {
        String sql = "SELECT COUNT(*) FROM payments WHERE paymentId = ? AND sellerId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentId);
            stmt.setString(2, sellerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Payment object
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getString("paymentId"));
        payment.setBuyerId(rs.getString("buyerId"));
        payment.setSellerId(rs.getString("sellerId"));
        payment.setApartmentId(rs.getString("apartmentId"));
        payment.setBuyerCardId(rs.getString("buyerCardId"));
        payment.setPaymentType(rs.getString("paymentType"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setStatus(rs.getString("status"));
        
        Timestamp paymentDate = rs.getTimestamp("paymentDate");
        if (paymentDate != null) payment.setPaymentDate(paymentDate.toLocalDateTime());
        
        payment.setDescription(rs.getString("description"));
        
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) payment.setCreatedAt(createdAt.toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) payment.setUpdatedAt(updatedAt.toLocalDateTime());

        return payment;
    }
    
    // Get payment count by seller
    public int getPaymentCountBySeller(String sellerId) {
        String sql = "SELECT COUNT(*) FROM payments p JOIN apartments a ON p.apartmentId = a.apartmentId WHERE a.sellerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total earnings by seller
    public double getTotalEarningsBySeller(String sellerId) {
        String sql = "SELECT ISNULL(SUM(p.amount), 0) FROM payments p JOIN apartments a ON p.apartmentId = a.apartmentId WHERE a.sellerId = ? AND p.status = 'Completed'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get payment count by buyer
    public int getPaymentCountByBuyer(String buyerId) {
        String sql = "SELECT COUNT(*) FROM payments WHERE buyerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total spent by buyer
    public double getTotalSpentByBuyer(String buyerId) {
        String sql = "SELECT ISNULL(SUM(amount), 0) FROM payments WHERE buyerId = ? AND status = 'Completed'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
