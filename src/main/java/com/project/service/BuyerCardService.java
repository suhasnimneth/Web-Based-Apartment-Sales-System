package com.project.service;

import com.project.DAO.BuyerCardDAO;
import com.project.model.BuyerCard;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class BuyerCardService {
    private BuyerCardDAO buyerCardDAO;

    public BuyerCardService() {
        this.buyerCardDAO = new BuyerCardDAO();
    }

    // Add a new buyer card
    public String addBuyerCard(String buyerId, String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard) {
        // Validate input
        if (buyerId == null || buyerId.trim().isEmpty()) {
            return null;
        }
        if (cardholderName == null || cardholderName.trim().isEmpty()) {
            return null;
        }
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return null;
        }
        if (cvv == null || cvv.trim().isEmpty()) {
            return null;
        }
        if (expiryDate == null) {
            return null;
        }
        if (amountInCard == null) {
            amountInCard = BigDecimal.ZERO;
        }

        // Check if card is expired
        if (expiryDate.isBefore(LocalDate.now())) {
            return null;
        }

        BuyerCard buyerCard = new BuyerCard(buyerId, cardholderName, cardNumber, cvv, expiryDate, amountInCard);
        return buyerCardDAO.addBuyerCard(buyerCard);
    }

    // Get all cards for a buyer
    public List<BuyerCard> getCardsByBuyerId(String buyerId) {
        if (buyerId == null || buyerId.trim().isEmpty()) {
            return new java.util.ArrayList<>();
        }
        return buyerCardDAO.getCardsByBuyerId(buyerId);
    }

    // Get a specific card by ID
    public BuyerCard getCardById(String buyerCardId) {
        if (buyerCardId == null || buyerCardId.trim().isEmpty()) {
            return null;
        }
        return buyerCardDAO.getCardById(buyerCardId);
    }

    // Update a buyer card
    public boolean updateBuyerCard(String buyerCardId, String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard) {
        // Validate input
        if (buyerCardId == null || buyerCardId.trim().isEmpty()) {
            return false;
        }
        if (cardholderName == null || cardholderName.trim().isEmpty()) {
            return false;
        }
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return false;
        }
        if (cvv == null || cvv.trim().isEmpty()) {
            return false;
        }
        if (expiryDate == null) {
            return false;
        }
        if (amountInCard == null) {
            amountInCard = BigDecimal.ZERO;
        }

        BuyerCard buyerCard = new BuyerCard();
        buyerCard.setBuyerCardId(buyerCardId);
        buyerCard.setCardholderName(cardholderName);
        buyerCard.setCardNumber(cardNumber);
        buyerCard.setCvv(cvv);
        buyerCard.setExpiryDate(expiryDate);
        buyerCard.setAmountInCard(amountInCard);

        return buyerCardDAO.updateBuyerCard(buyerCard);
    }

    // Delete a buyer card
    public boolean deleteBuyerCard(String buyerCardId) {
        if (buyerCardId == null || buyerCardId.trim().isEmpty()) {
            return false;
        }
        return buyerCardDAO.deleteBuyerCard(buyerCardId);
    }

    // Check if card belongs to buyer
    public boolean isCardOwnedByBuyer(String buyerCardId, String buyerId) {
        if (buyerCardId == null || buyerCardId.trim().isEmpty() || buyerId == null || buyerId.trim().isEmpty()) {
            return false;
        }
        return buyerCardDAO.isCardOwnedByBuyer(buyerCardId, buyerId);
    }

    // Get card count for a buyer
    public int getCardCountByBuyerId(String buyerId) {
        if (buyerId == null || buyerId.trim().isEmpty()) {
            return 0;
        }
        return buyerCardDAO.getCardCountByBuyerId(buyerId);
    }

    // Validate card number format (exactly 16 digits)
    public boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return false;
        }
        // Remove spaces and check if it's exactly 16 digits
        String cleanNumber = cardNumber.replaceAll("\\s+", "");
        return cleanNumber.matches("\\d{16}"); // Exactly 16 digits
    }

    // Validate CVV format (3 or 4 digits only)
    public boolean isValidCvv(String cvv) {
        if (cvv == null || cvv.trim().isEmpty()) {
            return false;
        }
        return cvv.matches("\\d{3}|\\d{4}"); // Exactly 3 or 4 digits
    }

    // Validate expiry date (must be future date)
    public boolean isValidExpiryDate(LocalDate expiryDate) {
        if (expiryDate == null) {
            return false;
        }
        return expiryDate.isAfter(LocalDate.now());
    }

    // Validate balance (cannot be negative)
    public boolean isValidBalance(BigDecimal balance) {
        if (balance == null) {
            return false;
        }
        return balance.compareTo(BigDecimal.ZERO) >= 0; // Greater than or equal to 0
    }

    // Validate required fields (no blank fields)
    public boolean isValidRequiredFields(String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard) {
        return cardholderName != null && !cardholderName.trim().isEmpty() &&
               cardNumber != null && !cardNumber.trim().isEmpty() &&
               cvv != null && !cvv.trim().isEmpty() &&
               expiryDate != null &&
               amountInCard != null;
    }

    // Comprehensive validation method
    public String validateCardData(String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard) {
        // Check required fields
        if (!isValidRequiredFields(cardholderName, cardNumber, cvv, expiryDate, amountInCard)) {
            return "All fields are required and cannot be empty";
        }

        // Validate cardholder name
        if (cardholderName.trim().length() < 2) {
            return "Cardholder name must be at least 2 characters long";
        }

        // Validate card number
        if (!isValidCardNumber(cardNumber)) {
            return "Card number must be exactly 16 digits";
        }

        // Validate CVV
        if (!isValidCvv(cvv)) {
            return "CVV must be exactly 3 or 4 digits";
        }

        // Validate expiry date
        if (!isValidExpiryDate(expiryDate)) {
            return "Expiry date must be a future date";
        }

        // Validate balance
        if (!isValidBalance(amountInCard)) {
            return "Balance cannot be negative";
        }

        return null; // No validation errors
    }
}
