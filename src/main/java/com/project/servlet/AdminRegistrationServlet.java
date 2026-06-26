package com.project.servlet;

import com.project.DAO.AdminDAO;
import com.project.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AdminRegistrationServlet")
public class AdminRegistrationServlet extends HttpServlet {
    
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminRegistrationServlet.doPost() called ===");
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        
        System.out.println("Registration attempt - Username: " + username + ", Email: " + email);
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            
            System.out.println("Missing required fields");
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            System.out.println("Password mismatch");
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            System.out.println("Password too short");
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if username already exists
            if (adminDAO.usernameExists(username.trim())) {
                System.out.println("Username already exists");
                request.setAttribute("error", "Username already exists");
                request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (adminDAO.emailExists(email.trim())) {
                System.out.println("Email already exists");
                request.setAttribute("error", "Email already exists");
                request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
                return;
            }
            
            // Create new admin
            Admin admin = new Admin(
                username.trim(),
                email.trim(),
                password.trim(),
                firstName.trim(),
                lastName.trim(),
                phone != null ? phone.trim() : null
            );
            
            String adminId = adminDAO.createAdmin(admin);
            
            if (adminId != null) {
                System.out.println("✅ Admin registered successfully with ID: " + adminId);
                request.setAttribute("success", "Admin registered successfully! You can now login.");
                request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            } else {
                System.out.println("❌ Admin registration failed");
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during admin registration: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminRegistrationServlet.doGet() called ===");
        
        // Forward to admin registration page
        request.getRequestDispatcher("adminregistration.jsp").forward(request, response);
    }
}
