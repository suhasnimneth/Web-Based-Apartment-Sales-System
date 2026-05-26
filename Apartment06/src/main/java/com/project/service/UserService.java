package com.project.service;

import com.project.DAO.UserDAO;
import com.project.model.Buyer;
import com.project.model.Seller;
import com.project.model.User;
import com.project.util.ValidationUtil;

import java.time.LocalDate;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public String registerUser(String firstName, String lastName, String contactNumber,
                               String address, String email, String password, String dateOfBirthStr,
                               String role, String preferredLocation, String budgetRange,
                               String purchaseTimeline, String businessRegistrationNumber,
                               String companyName, String licenseNumber) {

        try {
            // Validate inputs
            String validationError = validateInputs(firstName, lastName, contactNumber, address,
                    email, password, dateOfBirthStr, role,
                    preferredLocation, budgetRange, purchaseTimeline,
                    businessRegistrationNumber, companyName, licenseNumber);

            if (validationError != null) {
                return validationError;
            }

            LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr);

            // Check if email already exists
            if (userDAO.isEmailExists(email)) {
                return "Email already exists. Please use a different email.";
            }

            // Create user based on role
            boolean success = false;

            if ("buyer".equalsIgnoreCase(role)) {
                Buyer buyer = new Buyer(
                        firstName, lastName, contactNumber, address, email, password,
                        dateOfBirth,
                        ValidationUtil.isNotBlank(preferredLocation) ? preferredLocation : null,
                        budgetRange != null && !budgetRange.trim().isEmpty() ? Double.parseDouble(budgetRange) : null,
                        ValidationUtil.isNotBlank(purchaseTimeline) ? purchaseTimeline : null
                );

                // Insert into users table first, get generated userId (Uxxx)
                String generatedUserId = userDAO.insertUser(buyer);
                if (generatedUserId != null) {
                    buyer.setUserId(generatedUserId);
                    success = userDAO.insertBuyer(generatedUserId, buyer);
                }

            } else if ("seller".equalsIgnoreCase(role)) {
                Seller seller = new Seller(
                        firstName, lastName, contactNumber, address, email, password,
                        dateOfBirth,
                        ValidationUtil.isNotBlank(businessRegistrationNumber) ? businessRegistrationNumber : null,
                        ValidationUtil.isNotBlank(companyName) ? companyName : null,
                        ValidationUtil.isNotBlank(licenseNumber) ? licenseNumber : null
                );

                // Insert into users table first, get generated userId (Uxxx)
                String generatedUserId = userDAO.insertUser(seller);
                if (generatedUserId != null) {
                    seller.setUserId(generatedUserId);
                    success = userDAO.insertSeller(generatedUserId, seller);
                }
            }

            if (success) {
                return "success";
            } else {
                return "Registration failed. Please try again.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "An error occurred during registration: " + e.getMessage();
        }
    }

    private String validateInputs(String firstName, String lastName, String contactNumber,
                                  String address, String email, String password, String dateOfBirthStr,
                                  String role, String preferredLocation, String budgetRange,
                                  String purchaseTimeline, String businessRegistrationNumber,
                                  String companyName, String licenseNumber) {

        // Validate required fields
        if (!ValidationUtil.isNotBlank(firstName)) {
            return "First name is required.";
        }
        if (!ValidationUtil.isNotBlank(lastName)) {
            return "Last name is required.";
        }
        if (!ValidationUtil.isNotBlank(contactNumber)) {
            return "Contact number is required.";
        }
        if (!ValidationUtil.isNotBlank(address)) {
            return "Address is required.";
        }
        if (!ValidationUtil.isNotBlank(email)) {
            return "Email is required.";
        }
        if (!ValidationUtil.isNotBlank(password)) {
            return "Password is required.";
        }
        if (!ValidationUtil.isNotBlank(role)) {
            return "Role is required.";
        }

        // Validate contact number (10 digits)
        if (!ValidationUtil.isValidContactNumber(contactNumber)) {
            return "Contact number must be exactly 10 digits.";
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
        }

        // Validate password strength
        if (!ValidationUtil.isValidPassword(password)) {
            return "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.";
        }

        // Validate date of birth
        try {
            LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr);
            if (!ValidationUtil.isValidDateOfBirth(dateOfBirth)) {
                return "Date of birth cannot be in the future.";
            }
        } catch (Exception e) {
            return "Please enter a valid date of birth.";
        }

        // Validate role
        if (!"buyer".equalsIgnoreCase(role) && !"seller".equalsIgnoreCase(role)) {
            return "Invalid role selected.";
        }

        // Additional validations for buyer fields if role is buyer
        if ("buyer".equalsIgnoreCase(role)) {
            if (budgetRange != null && !budgetRange.trim().isEmpty()) {
                try {
                    Double.parseDouble(budgetRange);
                } catch (NumberFormatException e) {
                    return "Budget range must be a valid number.";
                }
            }
        }

        // Additional validations for seller fields if role is seller
        if ("seller".equalsIgnoreCase(role)) {
            if (ValidationUtil.isNotBlank(businessRegistrationNumber) && businessRegistrationNumber.length() > 100) {
                return "Business registration number is too long.";
            }
            if (ValidationUtil.isNotBlank(companyName) && companyName.length() > 100) {
                return "Company name is too long.";
            }
            if (ValidationUtil.isNotBlank(licenseNumber) && licenseNumber.length() > 100) {
                return "License number is too long.";
            }
        }

        return null; // No validation errors
    }

    // New login method
    public User authenticateUser(String email, String password, String role) {
        return userDAO.authenticateUser(email, password, role);
    }

    // Login without explicit role; role resolved from DB
    public User authenticateUser(String email, String password) {
        return userDAO.authenticateUser(email, password);
    }

    // Method to check if user exists
    public boolean userExists(String email, String role) {
        return userDAO.userExists(email, role);
    }
}