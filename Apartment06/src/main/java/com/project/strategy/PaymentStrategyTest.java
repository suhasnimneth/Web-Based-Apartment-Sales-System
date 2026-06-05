package com.project.strategy;

import java.math.BigDecimal;

/**
 * Test class demonstrate the Strategy Design Pattern implementation for payments.
 * This class shows how different payment strategies can be used interchangeably.
 */
public class PaymentStrategyTest {
    
    public static void main(String[] args) {
        System.out.println("=== Payment Strategy Pattern Test ===\n");
        
        // Test apartment price
        BigDecimal apartmentPrice = new BigDecimal("1000000"); // Rs. 10,00,000
        System.out.println("Apartment Price: Rs. " + apartmentPrice + "\n");
        
        // Test Advance Payment Strategy
        System.out.println("1. Testing Advance Payment Strategy:");
        PaymentStrategy advanceStrategy = PaymentStrategyFactory.getStrategy("advance");
        if (advanceStrategy != null) {
            System.out.println("   Payment Type: " + advanceStrategy.getPaymentType());
            System.out.println("   Amount: Rs. " + advanceStrategy.calculateAmount(apartmentPrice));
            System.out.println("   Description: " + advanceStrategy.getDescription(apartmentPrice));
            System.out.println("   Valid: " + advanceStrategy.isValid(apartmentPrice));
        }
        System.out.println();
        
        // Test Installment Payment Strategy
        System.out.println("2. Testing Installment Payment Strategy:");
        PaymentStrategy installmentStrategy = PaymentStrategyFactory.getStrategy("installment");
        if (installmentStrategy != null) {
            System.out.println("   Payment Type: " + installmentStrategy.getPaymentType());
            System.out.println("   Amount: Rs. " + installmentStrategy.calculateAmount(apartmentPrice));
            System.out.println("   Description: " + installmentStrategy.getDescription(apartmentPrice));
            System.out.println("   Valid: " + installmentStrategy.isValid(apartmentPrice));
        }
        System.out.println();
        
        // Test Half Payment Strategy
        System.out.println("3. Testing Half Payment Strategy:");
        PaymentStrategy halfStrategy = PaymentStrategyFactory.getStrategy("half");
        if (halfStrategy != null) {
            System.out.println("   Payment Type: " + halfStrategy.getPaymentType());
            System.out.println("   Amount: Rs. " + halfStrategy.calculateAmount(apartmentPrice));
            System.out.println("   Description: " + halfStrategy.getDescription(apartmentPrice));
            System.out.println("   Valid: " + halfStrategy.isValid(apartmentPrice));
        }
        System.out.println();
        
        // Test Factory methods
        System.out.println("4. Testing PaymentStrategyFactory:");
        System.out.println("   Available Payment Types: " + 
                          String.join(", ", PaymentStrategyFactory.getAvailablePaymentTypes()));
        System.out.println("   Is 'advance' supported: " + PaymentStrategyFactory.isSupported("advance"));
        System.out.println("   Is 'invalid' supported: " + PaymentStrategyFactory.isSupported("invalid"));
        System.out.println();
        
        // Test with invalid price
        System.out.println("5. Testing with Invalid Price:");
        BigDecimal invalidPrice = BigDecimal.ZERO;
        PaymentStrategy testStrategy = PaymentStrategyFactory.getStrategy("advance");
        if (testStrategy != null) {
            System.out.println("   Amount: Rs. " + testStrategy.calculateAmount(invalidPrice));
            System.out.println("   Description: " + testStrategy.getDescription(invalidPrice));
            System.out.println("   Valid: " + testStrategy.isValid(invalidPrice));
        }
        
        System.out.println("\n=== Strategy Pattern Test Completed ===");
    }
}
