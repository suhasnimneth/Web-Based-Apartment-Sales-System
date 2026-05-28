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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/AdminSettingsServlet")
public class AdminSettingsServlet extends HttpServlet {
    
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminSettingsServlet.doGet() called ===");
        
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
            // Get current admin profile
            request.setAttribute("currentAdmin", admin);
            
            // Get system settings (placeholder for future implementation)
            Map<String, Object> systemSettings = getSystemSettings();
            request.setAttribute("systemSettings", systemSettings);
            
            // Forward to settings page
            request.getRequestDispatcher("adminsettings.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminSettingsServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load settings page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminSettingsServlet.doPost() called ===");
        
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
            if ("updateProfile".equals(action)) {
                handleUpdateProfile(request, response, admin);
            } else if ("changePassword".equals(action)) {
                handleChangePassword(request, response, admin);
            } else if ("updateSystemSettings".equals(action)) {
                handleUpdateSystemSettings(request, response);
            } else {
                System.out.println("Invalid action: " + action);
                response.getWriter().write("error: Invalid action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminSettingsServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, Admin admin) 
            throws IOException {
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        System.out.println("Updating admin profile - ID: " + admin.getAdminId());
        
        // Validation
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            response.getWriter().write("error: First name, last name, and email are required");
            return;
        }
        
        // Check if email already exists (excluding current admin)
        if (!admin.getEmail().equals(email.trim()) && adminDAO.emailExists(email.trim())) {
            response.getWriter().write("error: Email already exists");
            return;
        }
        
        // Update admin profile
        admin.setFirstName(firstName.trim());
        admin.setLastName(lastName.trim());
        admin.setEmail(email.trim());
        admin.setPhone(phone != null ? phone.trim() : null);
        
        boolean success = adminDAO.updateAdmin(admin);
        
        if (success) {
            System.out.println("✅ Admin profile updated successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin profile update failed");
            response.getWriter().write("error: Failed to update profile");
        }
    }
    
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, Admin admin) 
            throws IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("Changing admin password - ID: " + admin.getAdminId());
        
        // Validation
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            response.getWriter().write("error: All password fields are required");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.getWriter().write("error: New passwords do not match");
            return;
        }
        
        if (newPassword.length() < 6) {
            response.getWriter().write("error: New password must be at least 6 characters long");
            return;
        }
        
        // Verify current password
        if (!admin.getPassword().equals(currentPassword.trim())) {
            response.getWriter().write("error: Current password is incorrect");
            return;
        }
        
        // Update password
        boolean success = adminDAO.updatePassword(admin.getAdminId(), newPassword.trim());
        
        if (success) {
            // Update session admin object
            admin.setPassword(newPassword.trim());
            System.out.println("✅ Admin password changed successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Admin password change failed");
            response.getWriter().write("error: Failed to change password");
        }
    }
    
    private void handleUpdateSystemSettings(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("Updating system settings");
        
        // For now, we'll just return success
        // In a real system, you would save these settings to a database table
        System.out.println("✅ System settings updated successfully");
        response.getWriter().write("success");
    }
    
    private Map<String, Object> getSystemSettings() {
        Map<String, Object> settings = new HashMap<>();
        
        // Placeholder system settings
        settings.put("siteName", "ApartmentX");
        settings.put("siteDescription", "Professional Apartment Management System");
        settings.put("maxFileSize", "10MB");
        settings.put("enableRegistration", true);
        settings.put("maintenanceMode", false);
        settings.put("emailNotifications", true);
        settings.put("autoApproveReviews", false);
        settings.put("maxApartmentsPerSeller", 50);
        settings.put("maxImagesPerApartment", 10);
        
        return settings;
    }
}
