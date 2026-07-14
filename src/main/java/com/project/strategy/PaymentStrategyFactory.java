package com.project.strategy;

import java.util.HashMap;
import java.util.Map;

/**
 * PaymentStrategyFactory creates and manages payment strategy instances.
 * This follows the Factory pattern to provide a centralized way to get
 * the appropriate payment strategy based on the payment type.
 */
public class PaymentStrategyFactory {

    private static final Map<String, PaymentStrategy> strategies = new HashMap<>();

    static {
        // Initialize all available payment strategies
        strategies.put("advance", new AdvancePaymentStrategy());
        strategies.put("installment", new InstallmentPaymentStrategy());
        strategies.put("half", new HalfPaymentStrategy());
    }

    /**
     * Gets the appropriate payment strategy based on the payment type.
     *
     * @param paymentType the type of payment (case-insensitive)
     * @return the corresponding PaymentStrategy instance, or null if not found
     */
    public static PaymentStrategy getStrategy(String paymentType) {
        if (paymentType == null || paymentType.trim().isEmpty()) {
            return null;
        }

        return strategies.get(paymentType.toLowerCase().trim());
    }

    /**
     * Gets all available payment types.
     *
     * @return array of available payment type names
     */
    public static String[] getAvailablePaymentTypes() {
        return strategies.keySet().toArray(new String[0]);
    }

    /**
     * Checks if a payment type is supported.
     *
     * @param paymentType the payment type to check
     * @return true if the payment type is supported, false otherwise
     */
    public static boolean isSupported(String paymentType) {
        return paymentType != null &&
                !paymentType.trim().isEmpty() &&
                strategies.containsKey(paymentType.toLowerCase().trim());
    }

    /**
     * Registers a new payment strategy.
     * This allows for dynamic addition of new payment strategies at runtime.
     *
     * @param paymentType the payment type name
     * @param strategy the PaymentStrategy implementation
     */
    public static void registerStrategy(String paymentType, PaymentStrategy strategy) {
        if (paymentType != null && strategy != null) {
            strategies.put(paymentType.toLowerCase().trim(), strategy);
        }
    }
}
