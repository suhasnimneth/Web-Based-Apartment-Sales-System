package com.project.util;

import java.time.LocalDate;
import java.util.regex.Pattern;

public class ValidationUtil {

    // Validate contact number (exactly 10 digits)
    public static boolean isValidContactNumber(String contactNumber) {
        if (contactNumber == null || contactNumber.trim().isEmpty()) {
            return false;
        }
        return Pattern.matches("\\d{10}", contactNumber.trim());
    }

    // Validate email format
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
        return Pattern.matches(emailRegex, email.trim());
    }

    // Validate strong password (at least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character)
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        // Check for at least one uppercase letter
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isLowerCase(c)) hasLower = true;
            else if (Character.isDigit(c)) hasDigit = true;
            else if (!Character.isLetterOrDigit(c)) hasSpecial = true;
        }

        return hasUpper && hasLower && hasDigit && hasSpecial;
    }

    // Validate date of birth (not in future)
    public static boolean isValidDateOfBirth(LocalDate dateOfBirth) {
        if (dateOfBirth == null) {
            return false;
        }
        return dateOfBirth.isBefore(LocalDate.now());
    }

    // Validate required fields are not empty
    public static boolean isNotBlank(String str) {
        return str != null && !str.trim().isEmpty();
    }
}