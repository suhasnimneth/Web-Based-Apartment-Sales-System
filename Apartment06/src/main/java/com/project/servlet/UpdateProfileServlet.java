package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;
import com.project.service.UserService;
import com.project.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    private UserService userService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get current user from session
            User currentUser = (User) session.getAttribute("user");
            String userId = currentUser.getUserId();

            // Get form parameters (only common fields)
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate inputs
            String validationError = validateInputs(firstName, lastName, email, contactNumber,
                    address, dateOfBirthStr, newPassword, confirmPassword);

            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
                return;
            }

            LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr);

            // Check if email already exists for another user
            if (!email.equals(currentUser.getEmail()) && userDAO.isEmailExistsForOtherUsers(email, userId)) {
                request.setAttribute("errorMessage", "Email already exists. Please use a different email.");
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
                return;
            }

            // Update user profile (only common fields)
            boolean success = updateUserProfile(userId, firstName, lastName, contactNumber, address,
                    email, dateOfBirth, newPassword);

            if (success) {
                // Update session with new user data
                updateSessionData(session, firstName, lastName, contactNumber, address,
                        email, dateOfBirth);

                request.setAttribute("successMessage", "Profile updated successfully!");
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating profile: " + e.getMessage());
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
        }
    }

    private String validateInputs(String firstName, String lastName, String email, String contactNumber,
                                  String address, String dateOfBirthStr, String newPassword,
                                  String confirmPassword) {

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

        // Validate contact number (10 digits)
        if (!ValidationUtil.isValidContactNumber(contactNumber)) {
            return "Contact number must be exactly 10 digits.";
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
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

        // Validate new password if provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                return "New password and confirmation do not match.";
            }
            if (!ValidationUtil.isValidPassword(newPassword)) {
                return "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.";
            }
        }

        return null; // No validation errors
    }

    private boolean updateUserProfile(String userId, String firstName, String lastName, String contactNumber,
                                      String address, String email, LocalDate dateOfBirth,
                                      String newPassword) {
        String updateUserSql = "UPDATE users SET firstName = ?, lastName = ?, contactNumber = ?, " +
                "address = ?, email = ?, dateOfBirth = ?, password = ? WHERE userId = ?";

        try (java.sql.Connection conn = com.project.util.DBUtil.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(updateUserSql)) {

            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, contactNumber);
            stmt.setString(4, address);
            stmt.setString(5, email);
            stmt.setDate(6, java.sql.Date.valueOf(dateOfBirth));

            // Only update password if new password is provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                stmt.setString(7, newPassword);
            } else {
                // Keep the current password
                stmt.setString(7, getExistingPassword(userId));
            }

            stmt.setString(8, userId);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String getExistingPassword(String userId) {
        String sql = "SELECT password FROM users WHERE userId = ?";
        try (java.sql.Connection conn = com.project.util.DBUtil.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            java.sql.ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("password");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void updateSessionData(HttpSession session, String firstName, String lastName, String contactNumber,
                                   String address, String email, LocalDate dateOfBirth) {
        // Update the user object in session
        User user = (User) session.getAttribute("user");
        if (user != null) {
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setContactNumber(contactNumber);
            user.setAddress(address);
            user.setEmail(email);
            user.setDateOfBirth(dateOfBirth);
            // Note: We don't update password in session for security reasons
        }
    }
}