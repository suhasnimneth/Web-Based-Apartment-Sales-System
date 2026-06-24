package com.project.service;

import com.project.DAO.PaymentDAO;
import com.project.model.Payment;
import com.project.model.Apartment;
import com.project.model.BuyerCard;
import com.project.strategy.PaymentStrategy;
import com.project.strategy.PaymentStrategyFactory;

import java.math.BigDecimal;
import java.util.List;

public class PaymentService {
    private PaymentDAO paymentDAO;
    private BuyerCardService buyerCardService;
    private ApartmentService apartmentService;

    public PaymentService() {
        this.paymentDAO = new PaymentDAO();
        this.buyerCardService = new BuyerCardService();
        this.apartmentService = new ApartmentService();
    }

    // Calculate payment amount using Strategy pattern
    public BigDecimal calculatePaymentAmount(String paymentType, BigDecimal apartmentPrice) {
        PaymentStrategy strategy = PaymentStrategyFactory.getStrategy(paymentType);
        if (strategy == null) {
            System.err.println("Unsupported payment type: " + paymentType);
            return BigDecimal.ZERO;
        }
        
        if (!strategy.isValid(apartmentPrice)) {
            System.err.println("Invalid apartment price for payment calculation: " + apartmentPrice);
            return BigDecimal.ZERO;
        }
        
        return strategy.calculateAmount(apartmentPrice);
    }

    // Get payment description using Strategy pattern
    public String getPaymentDescription(String paymentType, BigDecimal apartmentPrice) {
        PaymentStrategy strategy = PaymentStrategyFactory.getStrategy(paymentType);
        if (strategy == null) {
            return "Payment for apartment - Unsupported payment type: " + paymentType;
        }
        
        if (!strategy.isValid(apartmentPrice)) {
            return "Payment for apartment - Invalid price";
        }
        
        return strategy.getDescription(apartmentPrice);
    }

    // Process payment
    public String processPayment(String buyerId, String apartmentId, String buyerCardId, String paymentType) {
        System.out.println("=== PaymentService.processPayment ===");
        System.out.println("buyerId: " + buyerId);
        System.out.println("apartmentId: " + apartmentId);
        System.out.println("buyerCardId: " + buyerCardId);
        System.out.println("paymentType: " + paymentType);
        
        try {
            // Get apartment details
            Apartment apartment = apartmentService.getApartmentById(apartmentId);
            System.out.println("Apartment found: " + (apartment != null));
            if (apartment == null) {
                return "Apartment not found";
            }
            System.out.println("Apartment price: " + apartment.getPrice());

            // Calculate payment amount
            BigDecimal paymentAmount = calculatePaymentAmount(paymentType, apartment.getPrice());
            System.out.println("Payment amount calculated: " + paymentAmount);
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
                return "Invalid payment amount";
            }

            // Check if buyer has sufficient balance
            boolean hasBalance = paymentDAO.hasSufficientBalance(buyerCardId, paymentAmount);
            System.out.println("Has sufficient balance: " + hasBalance);
            if (!hasBalance) {
                return "Insufficient balance in selected card";
            }

            // Create payment record
            Payment payment = new Payment(
                buyerId,
                apartment.getSellerId(),
                apartmentId,
                buyerCardId,
                paymentType,
                paymentAmount,
                getPaymentDescription(paymentType, apartment.getPrice())
            );
            System.out.println("Payment object created");

            // Add payment to database
            String paymentId = paymentDAO.addPayment(payment);
            System.out.println("Payment ID returned: " + paymentId);
            if (paymentId == null) {
                return "Failed to create payment record";
            }

            // Deduct amount from card
            boolean deducted = paymentDAO.deductFromCard(buyerCardId, paymentAmount);
            System.out.println("Amount deducted from card: " + deducted);
            if (!deducted) {
                // If deduction failed, mark payment as failed
                paymentDAO.updatePaymentStatus(paymentId, "Failed");
                return "Payment failed - insufficient balance";
            }

            // Mark payment as completed
            paymentDAO.updatePaymentStatus(paymentId, "Completed");
            System.out.println("Payment marked as completed");

            // Mark apartment as Sold upon successful payment
            boolean statusUpdated = apartmentService.updateApartmentStatus(apartmentId, "Sold");
            System.out.println("Apartment status updated to Sold: " + statusUpdated);

            return "Payment completed successfully. Payment ID: " + paymentId;

        } catch (Exception e) {
            e.printStackTrace();
            return "Payment processing failed: " + e.getMessage();
        }
    }

    // Get all payments for a buyer
    public List<Payment> getPaymentsByBuyerId(String buyerId) {
        return paymentDAO.getPaymentsByBuyerId(buyerId);
    }

    // Get all payments for a seller
    public List<Payment> getPaymentsBySellerId(String sellerId) {
        return paymentDAO.getPaymentsBySellerId(sellerId);
    }

    // Get payments for a specific apartment
    public List<Payment> getPaymentsByApartment(String apartmentId) {
        return paymentDAO.getPaymentsByApartmentId(apartmentId);
    }

    // Get a specific payment
    public Payment getPaymentById(String paymentId) {
        return paymentDAO.getPaymentById(paymentId);
    }

    // Update payment status
    public boolean updatePaymentStatus(String paymentId, String status) {
        return paymentDAO.updatePaymentStatus(paymentId, status);
    }

    // Check if payment belongs to buyer
    public boolean isPaymentOwnedByBuyer(String paymentId, String buyerId) {
        return paymentDAO.isPaymentOwnedByBuyer(paymentId, buyerId);
    }

    // Check if payment belongs to seller
    public boolean isPaymentOwnedBySeller(String paymentId, String sellerId) {
        return paymentDAO.isPaymentOwnedBySeller(paymentId, sellerId);
    }

    // Validate payment data
    public String validatePaymentData(String buyerId, String apartmentId, String buyerCardId, String paymentType) {
        if (buyerId == null || buyerId.trim().isEmpty()) {
            return "Buyer ID is required";
        }

        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            return "Apartment ID is required";
        }

        if (buyerCardId == null || buyerCardId.trim().isEmpty()) {
            return "Card selection is required";
        }

        if (paymentType == null || paymentType.trim().isEmpty()) {
            return "Payment type is required";
        }

        // Validate payment type using Strategy pattern
        if (!PaymentStrategyFactory.isSupported(paymentType)) {
            return "Invalid payment type. Must be one of: " + 
                   String.join(", ", PaymentStrategyFactory.getAvailablePaymentTypes());
        }

        // Check if apartment exists
        Apartment apartment = apartmentService.getApartmentById(apartmentId);
        if (apartment == null) {
            return "Apartment not found";
        }

        // Check if buyer owns the card
        List<BuyerCard> buyerCards = buyerCardService.getCardsByBuyerId(buyerId);
        boolean cardExists = buyerCards.stream().anyMatch(card -> card.getBuyerCardId().equals(buyerCardId));
        if (!cardExists) {
            return "Invalid card selection";
        }

        return null; // No validation errors
    }
    
    // Get available payment types using Strategy pattern
    public String[] getAvailablePaymentTypes() {
        return PaymentStrategyFactory.getAvailablePaymentTypes();
    }
    
    // Get payment strategy information
    public String getPaymentStrategyInfo(String paymentType, BigDecimal apartmentPrice) {
        PaymentStrategy strategy = PaymentStrategyFactory.getStrategy(paymentType);
        if (strategy == null) {
            return "Unsupported payment type: " + paymentType;
        }
        
        if (!strategy.isValid(apartmentPrice)) {
            return "Invalid apartment price for payment calculation";
        }
        
        return String.format("Payment Type: %s\nAmount: Rs. %s\nDescription: %s",
                           strategy.getPaymentType(),
                           strategy.calculateAmount(apartmentPrice),
                           strategy.getDescription(apartmentPrice));
    }
}
