package com.project.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class BuyerCard {
    private String buyerCardId; // e.g., BC001
    private String buyerId;     // e.g., B001
    private String cardholderName;
    private String cardNumber;
    private String cvv;
    private LocalDate expiryDate;
    private BigDecimal amountInCard;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public BuyerCard() {}

    public BuyerCard(String buyerId, String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard) {
        this.buyerId = buyerId;
        this.cardholderName = cardholderName;
        this.cardNumber = cardNumber;
        this.cvv = cvv;
        this.expiryDate = expiryDate;
        this.amountInCard = amountInCard;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public BuyerCard(String buyerCardId, String buyerId, String cardholderName, String cardNumber, String cvv, LocalDate expiryDate, BigDecimal amountInCard, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.buyerCardId = buyerCardId;
        this.buyerId = buyerId;
        this.cardholderName = cardholderName;
        this.cardNumber = cardNumber;
        this.cvv = cvv;
        this.expiryDate = expiryDate;
        this.amountInCard = amountInCard;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getBuyerCardId() { return buyerCardId; }
    public void setBuyerCardId(String buyerCardId) { this.buyerCardId = buyerCardId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getCardholderName() { return cardholderName; }
    public void setCardholderName(String cardholderName) { this.cardholderName = cardholderName; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }

    public String getCvv() { return cvv; }
    public void setCvv(String cvv) { this.cvv = cvv; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

    public BigDecimal getAmountInCard() { return amountInCard; }
    public void setAmountInCard(BigDecimal amountInCard) { this.amountInCard = amountInCard; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Helper methods
    public String getMaskedCardNumber() {
        if (cardNumber == null || cardNumber.length() < 4) {
            return "****";
        }
        return "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
    }

    public boolean isExpired() {
        return expiryDate != null && expiryDate.isBefore(LocalDate.now());
    }

    @Override
    public String toString() {
        return "BuyerCard{" +
                "buyerCardId='" + buyerCardId + '\'' +
                ", buyerId='" + buyerId + '\'' +
                ", cardholderName='" + cardholderName + '\'' +
                ", cardNumber='" + getMaskedCardNumber() + '\'' +
                ", expiryDate=" + expiryDate +
                ", amountInCard=" + amountInCard +
                '}';
    }
}
