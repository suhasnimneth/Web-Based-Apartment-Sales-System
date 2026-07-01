package com.project.strategy;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * InstallmentPaymentStrategy implements the Strategy pattern for installment payments.
 * This strategy calculates monthly installment as 1/12 of the apartment price.
 */
public class InstallmentPaymentStrategy implements PaymentStrategy {
    
    private static final BigDecimal INSTALLMENT_DIVISOR = new BigDecimal("12");
    private static final String PAYMENT_TYPE = "Installment";
    
    @Override
    public BigDecimal calculateAmount(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        
        return apartmentPrice.divide(INSTALLMENT_DIVISOR, 2, RoundingMode.HALF_UP);
    }
    
    @Override
    public String getDescription(BigDecimal apartmentPrice) {
        if (apartmentPrice == null || apartmentPrice.compareTo(BigDecimal.ZERO) <= 0) {
            return "Monthly installment payment (1/12 of apartment price) - Invalid price";
        }
        
        BigDecimal amount = calculateAmount(apartmentPrice);
        return String.format("Monthly installment payment (1/12 of apartment price) - Rs. %s", 
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
