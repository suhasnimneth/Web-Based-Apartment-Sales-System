package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.UserDAO;
import com.project.model.Apartment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminApartmentManagementServlet")
public class AdminApartmentManagementServlet extends HttpServlet {
    
    private ApartmentDAO apartmentDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        apartmentDAO = new ApartmentDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminApartmentManagementServlet.doGet() called ===");
        
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
            // Get all apartments (this already includes primary images)
            List<Apartment> apartments = apartmentDAO.getAllApartments();
            System.out.println("Retrieved " + apartments.size() + " apartments");
            
            // For each apartment, get seller information
            for (Apartment apartment : apartments) {
                String sellerName = userDAO.getSellerNameBySellerId(apartment.getSellerId());
                apartment.setSellerName(sellerName);
                System.out.println("Apartment " + apartment.getApartmentId() + " - Primary image: " + apartment.getPrimaryImageUrl());
            }
            
            request.setAttribute("apartments", apartments);
            
            // Forward to apartment management page
            request.getRequestDispatcher("adminapartmentmanagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminApartmentManagementServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load apartment management page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminApartmentManagementServlet.doPost() called ===");
        
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
                handleDeleteApartment(request, response);
            } else if ("update".equals(action)) {
                handleUpdateApartment(request, response);
            } else {
                System.out.println("Invalid action: " + action);
                response.getWriter().write("error: Invalid action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminApartmentManagementServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void handleDeleteApartment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String apartmentId = request.getParameter("apartmentId");
        
        System.out.println("Deleting apartment - ID: " + apartmentId);
        
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            response.getWriter().write("error: Apartment ID is required");
            return;
        }
        
        // Delete apartment (this will cascade delete images)
        boolean success = apartmentDAO.deleteApartment(apartmentId);
        
        if (success) {
            System.out.println("✅ Apartment deleted successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Apartment deletion failed");
            response.getWriter().write("error: Failed to delete apartment");
        }
    }
    
    private void handleUpdateApartment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String apartmentId = request.getParameter("apartmentId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String priceStr = request.getParameter("price");
        
        System.out.println("Updating apartment - ID: " + apartmentId);
        
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            response.getWriter().write("error: Apartment ID is required");
            return;
        }
        
        // Get existing apartment
        Apartment apartment = apartmentDAO.getApartmentById(apartmentId);
        if (apartment == null) {
            response.getWriter().write("error: Apartment not found");
            return;
        }
        
        // Update fields if provided
        if (title != null && !title.trim().isEmpty()) {
            apartment.setTitle(title.trim());
        }
        if (description != null) {
            apartment.setDescription(description.trim());
        }
        if (address != null && !address.trim().isEmpty()) {
            apartment.setAddress(address.trim());
        }
        if (city != null && !city.trim().isEmpty()) {
            apartment.setCity(city.trim());
        }
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                apartment.setPrice(java.math.BigDecimal.valueOf(Double.parseDouble(priceStr)));
            } catch (NumberFormatException e) {
                response.getWriter().write("error: Invalid price format");
                return;
            }
        }
        
        // Update apartment
        boolean success = apartmentDAO.updateApartment(apartment);
        
        if (success) {
            System.out.println("✅ Apartment updated successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Apartment update failed");
            response.getWriter().write("error: Failed to update apartment");
        }
    }
}
