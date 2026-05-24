package com.project.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private String paymentId; // e.g., PAY001
    private String buyerId;   // e.g., B001
    private String sellerId;  // e.g., S001
    private String apartmentId; // e.g., A001
    private String buyerCardId; // e.g., BC001
    private String paymentType; // Advance, Installment, Half
    private BigDecimal amount;
    private String status; // Pending, Completed, Failed, Refunded
    private LocalDateTime paymentDate;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Payment() {}

    public Payment(String buyerId, String sellerId, String apartmentId, String buyerCardId, 
                   String paymentType, BigDecimal amount, String description) {
        this.buyerId = buyerId;
        this.sellerId = sellerId;
        this.apartmentId = apartmentId;
        this.buyerCardId = buyerCardId;
        this.paymentType = paymentType;
        this.amount = amount;
        this.status = "Pending";
        this.description = description;
        this.paymentDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Payment(String paymentId, String buyerId, String sellerId, String apartmentId, 
                   String buyerCardId, String paymentType, BigDecimal amount, String status, 
                   LocalDateTime paymentDate, String description, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.paymentId = paymentId;
        this.buyerId = buyerId;
        this.sellerId = sellerId;
        this.apartmentId = apartmentId;
        this.buyerCardId = buyerCardId;
        this.paymentType = paymentType;
        this.amount = amount;
        this.status = status;
        this.paymentDate = paymentDate;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getSellerId() { return sellerId; }
    public void setSellerId(String sellerId) { this.sellerId = sellerId; }

    public String getApartmentId() { return apartmentId; }
    public void setApartmentId(String apartmentId) { this.apartmentId = apartmentId; }

    public String getBuyerCardId() { return buyerCardId; }
    public void setBuyerCardId(String buyerCardId) { this.buyerCardId = buyerCardId; }

    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate) { this.paymentDate = paymentDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Helper methods
    public boolean isCompleted() {
        return "Completed".equals(status);
    }

    public boolean isPending() {
        return "Pending".equals(status);
    }

    public boolean isFailed() {
        return "Failed".equals(status);
    }

    public String getFormattedAmount() {
        return "Rs. " + amount;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentId='" + paymentId + '\'' +
                ", buyerId='" + buyerId + '\'' +
                ", sellerId='" + sellerId + '\'' +
                ", apartmentId='" + apartmentId + '\'' +
                ", paymentType='" + paymentType + '\'' +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                '}';
    }
}
