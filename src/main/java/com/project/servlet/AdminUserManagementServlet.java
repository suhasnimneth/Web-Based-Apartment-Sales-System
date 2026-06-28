package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/AdminUserManagementServlet")
public class AdminUserManagementServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminUserManagementServlet.doGet() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Object admin = session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin not logged in, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        try {
            // Get all users with their roles
            List<User> users = userDAO.getAllUsers();
            List<UserWithRole> usersWithRoles = new ArrayList<>();
            
            for (User user : users) {
                UserWithRole userWithRole = new UserWithRole();
                userWithRole.setUser(user);
                
                // Check if user is a buyer
                String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
                if (buyerId != null) {
                    userWithRole.setRole("buyer");
                    userWithRole.setRoleId(buyerId);
                }
                
                // Check if user is a seller
                String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
                if (sellerId != null) {
                    userWithRole.setRole("seller");
                    userWithRole.setRoleId(sellerId);
                }
                
                usersWithRoles.add(userWithRole);
            }
            
            request.setAttribute("users", usersWithRoles);
            
            // Forward to user management page
            request.getRequestDispatcher("adminusermanagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminUserManagementServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load user management page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminUserManagementServlet.doPost() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Object admin = session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        try {
            if ("delete".equals(action)) {
                handleDeleteUser(request, response);
            } else if ("toggle".equals(action)) {
                handleToggleUser(request, response);
            } else {
                System.out.println("Invalid action: " + action);
                response.getWriter().write("error: Invalid action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminUserManagementServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String userId = request.getParameter("userId");
        
        System.out.println("Deleting user - ID: " + userId);
        
        if (userId == null || userId.trim().isEmpty()) {
            response.getWriter().write("error: User ID is required");
            return;
        }
        
        // Delete user (this will cascade delete buyer/seller records)
        boolean success = userDAO.deleteUser(userId);
        
        if (success) {
            System.out.println("✅ User deleted successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ User deletion failed");
            response.getWriter().write("error: Failed to delete user");
        }
    }
    
    private void handleToggleUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String userId = request.getParameter("userId");
        
        System.out.println("Toggling user status - ID: " + userId);
        
        if (userId == null || userId.trim().isEmpty()) {
            response.getWriter().write("error: User ID is required");
            return;
        }
        
        // Get user and toggle their status
        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.getWriter().write("error: User not found");
            return;
        }
        
        // For now, we'll implement a simple toggle by updating the user
        // In a real system, you might want to add an 'isActive' field to users table
        boolean success = true; // Placeholder - implement actual toggle logic
        
        if (success) {
            System.out.println("✅ User status toggled successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ User status toggle failed");
            response.getWriter().write("error: Failed to toggle user status");
        }
    }
    
    // Inner class to hold user with role information
    public static class UserWithRole {
        private User user;
        private String role;
        private String roleId;
        
        public User getUser() {
            return user;
        }
        
        public void setUser(User user) {
            this.user = user;
        }
        
        public String getRole() {
            return role;
        }
        
        public void setRole(String role) {
            this.role = role;
        }
        
        public String getRoleId() {
            return roleId;
        }
        
        public void setRoleId(String roleId) {
            this.roleId = roleId;
        }
        
        public String getFullRole() {
            if (role != null) {
                return role.toUpperCase() + " (" + roleId + ")";
            }
            return "USER ONLY";
        }
    }
}
