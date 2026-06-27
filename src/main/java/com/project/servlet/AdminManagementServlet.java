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
import java.util.List;

@WebServlet("/AdminManagementServlet")
public class AdminManagementServlet extends HttpServlet {
    
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminManagementServlet.doGet() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin not logged in, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        try {
            // Get all admins
            List<Admin> admins = adminDAO.getAllAdmins();
            request.setAttribute("admins", admins);
            request.setAttribute("currentPage", "admins");
            
            // Forward to admin management page
            request.getRequestDispatcher("adminmanagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminManagementServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load admin management page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminManagementServlet.doPost() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        try {
            if ("add".equals(action)) {
                handleAddAdmin(request, response);
            } else if ("update".equals(action)) {
                handleUpdateAdmin(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteAdmin(request, response);
            } else if ("toggle".equals(action)) {
                handleToggleAdmin(request, response);
            } else {
                System.out.println("Invalid action: " + action);
                response.getWriter().write("error: Invalid action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminManagementServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void handleAddAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        
        System.out.println("Adding admin - Username: " + username + ", Email: " + email);
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            
            response.getWriter().write("error: All required fields must be filled");
            return;
        }
        
        if (password.length() < 6) {
            response.getWriter().write("error: Password must be at least 6 characters long");
            return;
        }
        
        // Check if username or email already exists
        if (adminDAO.usernameExists(username.trim())) {
            response.getWriter().write("error: Username already exists");
            return;
        }
        
        if (adminDAO.emailExists(email.trim())) {
            response.getWriter().write("error: Email already exists");
            return;
        }
        
        // Create new admin
        Admin newAdmin = new Admin(
            username.trim(),
            email.trim(),
            password.trim(),
            firstName.trim(),
            lastName.trim(),
            phone != null ? phone.trim() : null
        );
        
        String adminId = adminDAO.createAdmin(newAdmin);
        
        if (adminId != null) {
            System.out.println("✅ Admin created successfully with ID: " + adminId);
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin creation failed");
            response.getWriter().write("error: Failed to create admin");
        }
    }
    
    private void handleUpdateAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String adminId = request.getParameter("adminId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        
        System.out.println("Updating admin - ID: " + adminId + ", Username: " + username);
        
        // Validation
        if (adminId == null || adminId.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            
            response.getWriter().write("error: All required fields must be filled");
            return;
        }
        
        // Get existing admin
        Admin existingAdmin = adminDAO.getAdminById(adminId);
        if (existingAdmin == null) {
            response.getWriter().write("error: Admin not found");
            return;
        }
        
        // Check if username or email already exists (excluding current admin)
        if (!existingAdmin.getUsername().equals(username.trim()) && adminDAO.usernameExists(username.trim())) {
            response.getWriter().write("error: Username already exists");
            return;
        }
        
        if (!existingAdmin.getEmail().equals(email.trim()) && adminDAO.emailExists(email.trim())) {
            response.getWriter().write("error: Email already exists");
            return;
        }
        
        // Update admin
        existingAdmin.setUsername(username.trim());
        existingAdmin.setEmail(email.trim());
        existingAdmin.setFirstName(firstName.trim());
        existingAdmin.setLastName(lastName.trim());
        existingAdmin.setPhone(phone != null ? phone.trim() : null);
        
        boolean success = adminDAO.updateAdmin(existingAdmin);
        
        if (success) {
            System.out.println("✅ Admin updated successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin update failed");
            response.getWriter().write("error: Failed to update admin");
        }
    }
    
    private void handleDeleteAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String adminId = request.getParameter("adminId");
        
        System.out.println("Deleting admin - ID: " + adminId);
        
        if (adminId == null || adminId.trim().isEmpty()) {
            response.getWriter().write("error: Admin ID is required");
            return;
        }
        
        // Check if admin exists
        Admin admin = adminDAO.getAdminById(adminId);
        if (admin == null) {
            response.getWriter().write("error: Admin not found");
            return;
        }
        
        // Soft delete admin
        boolean success = adminDAO.deleteAdmin(adminId);
        
        if (success) {
            System.out.println("✅ Admin deleted successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin deletion failed");
            response.getWriter().write("error: Failed to delete admin");
        }
    }
    
    private void handleToggleAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String adminId = request.getParameter("adminId");
        
        System.out.println("Toggling admin status - ID: " + adminId);
        
        if (adminId == null || adminId.trim().isEmpty()) {
            response.getWriter().write("error: Admin ID is required");
            return;
        }
        
        // Get existing admin
        Admin admin = adminDAO.getAdminById(adminId);
        if (admin == null) {
            response.getWriter().write("error: Admin not found");
            return;
        }
        
        // Toggle active status
        admin.setActive(!admin.isActive());
        
        boolean success = adminDAO.updateAdmin(admin);
        
        if (success) {
            System.out.println("✅ Admin status toggled successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin status toggle failed");
            response.getWriter().write("error: Failed to toggle admin status");
        }
    }
}
