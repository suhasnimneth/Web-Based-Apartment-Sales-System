package com.project.strategy;

import java.math.BigDecimal;

public interface PaymentStrategy {

    /**
     * Calculates the payment amount based on the apartment price and payment strategy.
     *
     * @param apartmentPrice the total price of the apartment
     * @return the calculated payment amount
     */
    BigDecimal calculateAmount(BigDecimal apartmentPrice);

    /**
     * Gets the description for this payment type.
     *
     * @param apartmentPrice the total price of the apartment
     * @return a descriptive string explaining the payment calculation
     */
    String getDescription(BigDecimal apartmentPrice);

    /**
     * Gets the payment type name.
     *
     * @return the name of this payment type (e.g., "Advance", "Installment", "Half")
     */
    String getPaymentType();

    /**
     * Validates if this payment strategy can be applied.
     *
     * @param apartmentPrice the total price of the apartment
     * @return true if this strategy can be applied, false otherwise
     */
    boolean isValid(BigDecimal apartmentPrice);
}
