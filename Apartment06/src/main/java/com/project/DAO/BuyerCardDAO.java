package com.project.DAO;

import com.project.model.BuyerCard;
import com.project.util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuyerCardDAO {

    // Add a new buyer card
    public String addBuyerCard(BuyerCard buyerCard) {
        String sql = "INSERT INTO buyerCards (buyerId, cardholderName, cardNumber, cvv, expiryDate, amountInCard) OUTPUT INSERTED.buyerCardId VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCard.getBuyerId());
            stmt.setString(2, buyerCard.getCardholderName());
            stmt.setString(3, buyerCard.getCardNumber());
            stmt.setString(4, buyerCard.getCvv());
            stmt.setDate(5, Date.valueOf(buyerCard.getExpiryDate()));
            stmt.setBigDecimal(6, buyerCard.getAmountInCard());

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

    // Get all cards for a specific buyer
    public List<BuyerCard> getCardsByBuyerId(String buyerId) {
        String sql = "SELECT buyerCardId, buyerId, cardholderName, cardNumber, cvv, expiryDate, amountInCard, createdAt, updatedAt FROM buyerCards WHERE buyerId = ? ORDER BY createdAt DESC";

        List<BuyerCard> cards = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                BuyerCard card = new BuyerCard();
                card.setBuyerCardId(rs.getString("buyerCardId"));
                card.setBuyerId(rs.getString("buyerId"));
                card.setCardholderName(rs.getString("cardholderName"));
                card.setCardNumber(rs.getString("cardNumber"));
                card.setCvv(rs.getString("cvv"));
                
                Date expiryDate = rs.getDate("expiryDate");
                if (expiryDate != null) card.setExpiryDate(expiryDate.toLocalDate());
                
                BigDecimal amount = rs.getBigDecimal("amountInCard");
                card.setAmountInCard(amount != null ? amount : BigDecimal.ZERO);
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) card.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) card.setUpdatedAt(updatedAt.toLocalDateTime());

                cards.add(card);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cards;
    }

    // Get a specific card by ID
    public BuyerCard getCardById(String buyerCardId) {
        String sql = "SELECT buyerCardId, buyerId, cardholderName, cardNumber, cvv, expiryDate, amountInCard, createdAt, updatedAt FROM buyerCards WHERE buyerCardId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCardId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                BuyerCard card = new BuyerCard();
                card.setBuyerCardId(rs.getString("buyerCardId"));
                card.setBuyerId(rs.getString("buyerId"));
                card.setCardholderName(rs.getString("cardholderName"));
                card.setCardNumber(rs.getString("cardNumber"));
                card.setCvv(rs.getString("cvv"));
                
                Date expiryDate = rs.getDate("expiryDate");
                if (expiryDate != null) card.setExpiryDate(expiryDate.toLocalDate());
                
                BigDecimal amount = rs.getBigDecimal("amountInCard");
                card.setAmountInCard(amount != null ? amount : BigDecimal.ZERO);
                
                Timestamp createdAt = rs.getTimestamp("createdAt");
                if (createdAt != null) card.setCreatedAt(createdAt.toLocalDateTime());
                
                Timestamp updatedAt = rs.getTimestamp("updatedAt");
                if (updatedAt != null) card.setUpdatedAt(updatedAt.toLocalDateTime());

                return card;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update a buyer card
    public boolean updateBuyerCard(BuyerCard buyerCard) {
        String sql = "UPDATE buyerCards SET cardholderName = ?, cardNumber = ?, cvv = ?, expiryDate = ?, amountInCard = ?, updatedAt = SYSUTCDATETIME() WHERE buyerCardId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCard.getCardholderName());
            stmt.setString(2, buyerCard.getCardNumber());
            stmt.setString(3, buyerCard.getCvv());
            stmt.setDate(4, Date.valueOf(buyerCard.getExpiryDate()));
            stmt.setBigDecimal(5, buyerCard.getAmountInCard());
            stmt.setString(6, buyerCard.getBuyerCardId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a buyer card
    public boolean deleteBuyerCard(String buyerCardId) {
        String sql = "DELETE FROM buyerCards WHERE buyerCardId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCardId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if card belongs to buyer
    public boolean isCardOwnedByBuyer(String buyerCardId, String buyerId) {
        String sql = "SELECT COUNT(*) FROM buyerCards WHERE buyerCardId = ? AND buyerId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerCardId);
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

    // Get card count for a buyer
    public int getCardCountByBuyerId(String buyerId) {
        String sql = "SELECT COUNT(*) FROM buyerCards WHERE buyerId = ?";

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
}
