package com.project.servlet;

import com.project.service.UserService;
import com.project.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters and store them in request attributes for form re-population
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String role = request.getParameter("role");

            // Buyer specific fields
            String preferredLocation = request.getParameter("preferredLocation");
            String budgetRange = request.getParameter("budgetRange");
            String purchaseTimeline = request.getParameter("purchaseTimeline");

            // Seller specific fields
            String businessRegistrationNumber = request.getParameter("businessRegistrationNumber");
            String companyName = request.getParameter("companyName");
            String licenseNumber = request.getParameter("licenseNumber");

            // Validate password strength
            if (!PasswordUtil.isPasswordStrong(password)) {
                request.setAttribute("errorMessage", "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#$%^&*()_+-=[]{}|;:,.<>?)");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Store form data in request attributes to preserve values on validation failure
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("contactNumber", contactNumber);
            request.setAttribute("address", address);
            request.setAttribute("email", email);
            request.setAttribute("password", password);
            request.setAttribute("dateOfBirth", dateOfBirth);
            request.setAttribute("role", role);

            // Store role-specific fields
            request.setAttribute("preferredLocation", preferredLocation);
            request.setAttribute("budgetRange", budgetRange);
            request.setAttribute("purchaseTimeline", purchaseTimeline);
            request.setAttribute("businessRegistrationNumber", businessRegistrationNumber);
            request.setAttribute("companyName", companyName);
            request.setAttribute("licenseNumber", licenseNumber);

            // Register user
            String result = userService.registerUser(
                    firstName, lastName, contactNumber, address, email, password,
                    dateOfBirth, role, preferredLocation, budgetRange, purchaseTimeline,
                    businessRegistrationNumber, companyName, licenseNumber
            );

            if ("success".equals(result)) {
                // Registration successful — set flash message and redirect to login page
                HttpSession session = request.getSession();
                session.setAttribute("flashSuccess", "Registration successful. Please login.");
                response.sendRedirect("login.jsp");
            } else {
                // Registration failed — show error and stay on register page
                request.setAttribute("errorMessage", result);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }


        } catch (Exception e) {
            e.printStackTrace();
            // Preserve form data even on exception
            preserveFormData(request);
            request.setAttribute("errorMessage", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to register page for GET requests
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    // Helper method to auto-login after successful registration
    private void autoLogin(HttpServletRequest request, HttpServletResponse response,
                           String email, String password) throws IOException {
        try {
            // Authenticate the user (same logic as login servlet)
            com.project.model.User user = authenticateUser(email, password);

            if (user != null) {
                // Create session and store user info
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userName", user.getFirstName() + " " + user.getLastName());

                // Redirect based on role
                if ("buyer".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("buyerdashboard.jsp");
                } else if ("seller".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("sellerdashboard.jsp");
                } else {
                    response.sendRedirect("home.jsp");
                }
            } else {
                // This shouldn't happen, but redirect to login if auth fails
                response.sendRedirect("login.jsp?success=Registration successful. Please login.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?success=Registration successful. Please login.");
        }
    }

    private com.project.model.User authenticateUser(String email, String password) {
        String sql = "SELECT userId, firstName, lastName, contactNumber, address, email, password, dateOfBirth, role, registrationDate FROM users WHERE email = ? AND password = ?";

        try (java.sql.Connection conn = com.project.util.DBUtil.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            java.sql.ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                com.project.model.User user = new com.project.model.User();
                user.setUserId(rs.getString("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setContactNumber(rs.getString("contactNumber"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime().toLocalDate());

                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Helper method to preserve form data on exception
    private void preserveFormData(HttpServletRequest request) {
        String[] formFields = {
                "firstName", "lastName", "contactNumber", "address", "email", "password",
                "dateOfBirth", "role", "preferredLocation", "budgetRange", "purchaseTimeline",
                "businessRegistrationNumber", "companyName", "licenseNumber"
        };

        for (String field : formFields) {
            String value = request.getParameter(field);
            if (value != null) {
                request.setAttribute(field, value);
            }
        }
    }
}