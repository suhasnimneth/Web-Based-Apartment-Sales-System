package com.project.strategy;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * AdvancePaymentStrategy implements the Strategy pattern for advance payments.
 * This strategy calculates 10% of the apartment price as advance payment.
 */
public class AdvancePaymentStrategy implements PaymentStrategy {
    
    private static final BigDecimal ADVANCE_PERCENTAGE = new BigDecimal("0.10");
    private static final String PAYMENT_TYPE = "Advance";
    
    @Override
    public BigDecimal calculateAmount(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        return apartmentPrice.multiply(ADVANCE_PERCENTAGE)
                           .setScale(2, RoundingMode.HALF_UP);
    }
    
    @Override
    public String getDescription(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return "Advance payment (10% of apartment price) - Invalid price";
        }
        
        BigDecimal amount = calculateAmount(apartmentPrice);
        return String.format("Advance payment (10%% of apartment price) - Rs. %s", 
                            amount.toString());
    }
    
    @Override
    public String getPaymentType() {
        return PAYMENT_TYPE;
    }
    
    @Override
    public boolean isValid(BigDecimal apartmentPrice) {
        return apartmentPrice != null && apartmentPrice.compareTo(BigDecimal.ZERO) > 0;
    }
}
