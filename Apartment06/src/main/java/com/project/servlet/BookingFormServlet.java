package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/BookingFormServlet")
public class BookingFormServlet extends HttpServlet {
    
    private ApartmentDAO apartmentDAO;
    
    @Override
    public void init() throws ServletException {
        apartmentDAO = new ApartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== BookingFormServlet.doGet() called ===");
        
        // Get apartment ID from request parameters
        String apartmentId = request.getParameter("apartmentId");
        System.out.println("Retrieved apartmentId from request: " + apartmentId);
        
        // Debug: Print all request parameters
        System.out.println("=== ALL REQUEST PARAMETERS ===");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println(key + ": " + java.util.Arrays.toString(values));
        });
        
        // Validate apartment ID
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            System.out.println("❌ Apartment ID is null or empty, redirecting to apartments.jsp");
            response.sendRedirect("apartments.jsp");
            return;
        }
        
        System.out.println("✅ Apartment ID validation passed: " + apartmentId);
        
        try {
            // Get apartment details from database
            System.out.println("Calling apartmentDAO.getApartmentById(" + apartmentId + ")");
            Apartment apartment = apartmentDAO.getApartmentById(apartmentId);
            
            if (apartment == null) {
                System.out.println("❌ Apartment not found in database for ID: " + apartmentId);
                response.sendRedirect("BuyerDashboardServlet");
                return;
            }
            
            System.out.println("✅ Apartment found successfully:");
            System.out.println("  - Apartment ID: " + apartment.getApartmentId());
            System.out.println("  - Title: " + apartment.getTitle());
            System.out.println("  - Seller ID: " + apartment.getSellerId());
            System.out.println("  - Price: " + apartment.getPrice());
            
            // Set apartment in request attributes
            request.setAttribute("apartment", apartment);
            System.out.println("✅ Apartment set in request attributes");
            
            // Store apartmentId in session as backup
            request.getSession().setAttribute("currentApartmentId", apartment.getApartmentId());
            System.out.println("✅ Apartment ID stored in session: " + apartment.getApartmentId());
            
            // Forward to booking form
            System.out.println("Forwarding to bookingform.jsp");
            request.getRequestDispatcher("bookingform.jsp").forward(request, response);
            System.out.println("✅ Successfully forwarded to bookingform.jsp");
            
        } catch (Exception e) {
            System.err.println("❌ Error in BookingFormServlet: " + e.getMessage());
            System.err.println("Exception type: " + e.getClass().getSimpleName());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            response.sendRedirect("BuyerDashboardServlet");
        }
    }
}
