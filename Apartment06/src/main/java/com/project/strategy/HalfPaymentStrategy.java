package com.project.strategy;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * HalfPaymentStrategy implements the Strategy pattern for half payments.
 * This strategy calculates 50% of the apartment price as half payment.
 */
public class HalfPaymentStrategy implements PaymentStrategy {
    
    private static final BigDecimal HALF_PERCENTAGE = new BigDecimal("0.50");
    private static final String PAYMENT_TYPE = "Half";
    
    @Override
    public BigDecimal calculateAmount(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        return apartmentPrice.multiply(HALF_PERCENTAGE)
                           .setScale(2, RoundingMode.HALF_UP);
    }
    
    @Override
    public String getDescription(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return "Half payment (50% of apartment price) - Invalid price";
        }
        
        BigDecimal amount = calculateAmount(apartmentPrice);
        return String.format("Half payment (50%% of apartment price) - Rs. %s", 
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
