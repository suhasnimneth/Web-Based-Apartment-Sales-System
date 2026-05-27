package com.project.servlet;

import com.project.DAO.AdminDAO;
import com.project.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminLoginServlet.doPost() called ===");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt - Username: " + username);
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.out.println("Missing username or password");
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            return;
        }
        
        try {
            // Authenticate admin
            Admin admin = adminDAO.authenticateAdmin(username.trim(), password.trim());
            
            if (admin != null) {
                System.out.println("✅ Admin login successful: " + admin.getUsername());
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                session.setAttribute("userRole", "admin");
                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("adminName", admin.getFullName());
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                // Redirect to admin dashboard servlet to load statistics
                response.sendRedirect("AdminDashboardServlet");
                
            } else {
                System.out.println("❌ Admin login failed - Invalid credentials");
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during admin login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again.");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminLoginServlet.doGet() called ===");
        
        // Check if admin is already logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin != null && "admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin already logged in, redirecting to dashboard servlet");
            response.sendRedirect("AdminDashboardServlet");
            return;
        }
        
        // Forward to admin login page
        request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
    }
}
